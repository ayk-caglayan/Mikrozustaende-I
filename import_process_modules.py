#import and process chosen module according to given parameters and exports as .xml file

import matplotlib.pyplot as plt
import random

from musx import rescale, interp
from scamp import *
from scamp_extensions.pitch import *

def p_soprano_part():
    for s_f, s_d in zip(soprano_freq, soprano_dur_env):
        piano1.play_note(hertz_to_midi(s_f), 1, s_d)
def p_alto_part():
    for a_f, a_d in zip(alto_freq, alto_dur_env):
        piano2.play_note(hertz_to_midi(a_f), 1, a_d)
def p_tenor_part():
    for t_f, t_d in zip(tenor_freq, tenor_dur_env):
        piano3.play_note(hertz_to_midi(t_f), 1, t_d)
def p_bass_part():
    for b_f, b_d in zip(bass_freq, bass_dur_env):
        piano4.play_note(hertz_to_midi(b_f), 1, b_d)

def concatenate(list_of_lists):
    out=[]
    for l in list_of_lists:
        for r in l:
            out.append(r)
    return out

#replaces x with y
def replace(a, x, y):
    for ind, ele in enumerate(a):
        if ele==x:
            a[ind]=y
    return a

#returns an array of numbers ranging from a to b, steps up at given step value
def my_range(a,b,step):
    ruler=[a]
    start=a
    stop=b
    while a<=b:
        a+=step
        ruler.append(round(a, 3))
    return ruler

#quantizes number to a given step size.
def quantize(x, step):
    board=my_range(int(x), int(x)+1, step)
    return min(board, key=lambda y: abs(y-x))

#quantize numbers in the list to a given step size
def quantize_list(liste, step_size=0.25):
    out=[]
    for i in liste:
        out.append(quantize(i, step_size))
    out=replace(out, 0, step_size) #prohibits 0 as dur value
    return out

# A.D.R. (3 point) style rhythmic series accel. decel. based on musx.envelope interp #
# interp([1,1,1,1], 0,1,0.33, 2, 0.66, 4, 1,0.5)
def rhythm_enveloper_in_beats(dur_series, a_scaler=1, d_scaler=1, r_scaler=1, quantize_bit=0.25):
    out=[]
    series_in_beats=chop_in_beats(dur_series)
    for beat in enumerate(series_in_beats):
        normalized_beat_nr=beat[0]/(len(series_in_beats)-1)
        #scaler=musx.interp(normalized_beat_nr, 0, a_scaler, 0.5, d_scaler, 1, r_scaler)
        scaler=interp(normalized_beat_nr, 0, a_scaler, 0.5, d_scaler, 1, r_scaler)
        enveloped_rhy=list(map(lambda x: quantize(x*scaler, quantize_bit), beat[1]))
        out.append(enveloped_rhy)
    return out



#packages dur values in beats
def chop_in_beats(arr, beat_len=0.89):
    liste=arr.copy()
    out=[]
    in_out=[]
    pops=[]
    # sequentially adds up durations and pack into given lengths
    for i in liste:
        in_out.append(i)
        #print(i, in_out)
        if sum(in_out)>=beat_len:
            out.append(in_out)
            in_out=[]
        else:
            continue
    # appends the rest, which are shorter than beat_len
    pops=concatenate(out) #flattens out list to loop over
    for p in range(len(pops)):
        liste.pop(0) #the packed durations are removed from the given duration list
    if liste:
        out.append(liste)
    return out


#repack a list of numbers(durations) into sub-arrays of given sum
def reframe(a, summe=3):
    main_out=[]
    out=[]
    counter=0
    for i in a:
        out.append(i)
        #print("block_1", counter, i, out)
        if sum(out)>=summe and not counter==len(a)-1:
            main_out.append(out)
            if not counter==len(a)-1: #when it's last element, keep it to append
                #print("block_2:1",counter, i, out)
                out=[]
            else:
                pass
            #print("block_2:2", counter, i, out)
        if counter==len(a)-1: #this to append the uncompleted rest into the array
            #out.append(i)

            if sum(out)<2 and sum(main_out[len(main_out)-1])<=3: #if shorter than two beats append it to the last frame
                #print("block_3:1", counter, i, out)
                out=concatenate([main_out[len(main_out)-1], out])
                main_out[len(main_out)-1]=out
            elif sum(out)<0.75:
                #print("block_3:2", counter, i, out)
                out=concatenate([main_out[len(main_out)-1], out])
                main_out[len(main_out)-1]=out

            else: #if longer than 2 beats pack it as a seperate frame
                #print("block_3:3", counter, i, out)
                main_out.append(out)
        counter+=1
    return main_out

#interprets and returns given sub-arrays as time signatures
def sechszehntelORachtelORviertel(ref_out):
    out=[]

    for bar in ref_out:
        bar=quantize_list(bar, 0.25)
        print(bar, sum(bar))
        if sum(bar)%1==0:
            out.append(str(int(sum(bar)*1))+"/"+str(4))
            #print(str(int(sum(bar)*1))+'/'+str(4))
        elif sum(bar)%0.5==0:
            out.append(str(int(sum(bar)*2))+"/"+str(8))
            #print(str(int(sum(bar)*2))+'/'+str(8))
        elif sum(bar)%0.25==0:
            out.append(str(int(sum(bar)*4))+"/"+str(16))
            #print(str(int(sum(bar)*4))+'/'+str(16))
    return out


def normalizeSum(np_array):
    return np_array/np_array.sum()

def get_module_length(module_file_readed_lines, module_nr):
    len_sum=[]
    for mode_line in module_file_readed_lines:
        mode_line=mode_line.split('\t')
        if (int(mode_line[0])==module_nr) and (int(mode_line[1])==1):
            len_sum.append(float(mode_line[5]))
    return(sum(len_sum))

def return_longest(*lists):
    lengths=[]
    longest_arr=None
    for i in lists:
        lengths.append(len(i))
    longest_=max(lengths)
    for l in lists:
        if len(l)==longest_:
            longest_arr=l
    print("longestin özü", longest_arr)
    return longest_arr

def return_shortest(*lists):
    lengths=[]
    shortest_arr=None
    for i in lists:
        lengths.append(len(i))
    shortest_=min(lengths)
    for l in lists:
        if len(l)==shortest_:
            shortest_arr=l
    print("shortest'in özü", shortest_arr)
    return shortest_arr

# adjust the array's total sum to the given value by chopping from tail or adding extras
def equalize(a, target_sum):
    diff=target_sum-sum(a)
    if diff>0: #when target_sum is larger than the given array
        a.append(diff)
        return a
    elif diff<0: #when target_sum is smaller than the given array
        diff=abs(diff)
        if a[len(a)-1]>diff:
            a[len(a)-1]=a[len(a)-1]-diff
        elif a[len(a)-1]==diff:
            a.pop(len(a)-1)
        elif a[len(a)-1]<diff:
            a.pop(len(a)-1)
            equalize(a, target_sum)
    return a

# get module numbers with the given (l)ength (in beats), (k)ey and (m)ode
def get_module_w_len_key_mode(l, k, m):
    out=[]
    alternative_durs={}

    if m=='maj':
        for i in major_key_dic[k]:
            if i[1]==l:
                out.append(i[0])
            else:
                #alternative_durs[i[1]].append(i[0]) # a dic key as duration, value as mod_nr
                if alternative_durs.get(i[1]):
                    alternative_durs[i[1]].append(i[0])
                else:
                    alternative_durs[i[1]]=[]
                    alternative_durs[i[1]].append(i[0])
        if len(out)!=0:
            print("modules in key ",k,m, "with length ", l, ": ", out  )
            return out
        elif len(alternative_durs)==0:
            return get_module_w_len_key_mode(l,k,'min')
        else:
            alternate=min(alternative_durs, key=lambda x:abs(x-l))
            print("closest available module length in key ",k,m, " is ", alternate)
            #return alternative_durs[alternate]
            return get_module_w_len_key_mode(alternate, k,m)

    if m=='min':
        for i in minor_key_dic[k]:
            if i[1]==l:
                out.append(i[0])
            else:
                #alternative_durs[i[1]].append(i[0]) # a dic key as duration, value as mod_nr
                if alternative_durs.get(i[1]):
                    alternative_durs[i[1]].append(i[0])
                else:
                    alternative_durs[i[1]]=[]
                    alternative_durs[i[1]].append(i[0])

        if len(out)!=0:
            print("modules in key", k, m, "with length ", l, ": ", out  )
            return out
        elif len(alternative_durs)==0:
            return get_module_w_len_key_mode(l,k,'maj') #tries same length and key with other mode setting
        else:
            alternate=min(alternative_durs, key=lambda x:abs(x-l))
            print("closest available module length in key ", k, m, " is ", alternate)
            #return alternative_durs[alternate]
            return get_module_w_len_key_mode(alternate,k,m)


def import_process_beats_aligned(module_file_path, module_nr=230, bottom=65, ceiling=1056, quantize_step_size=0.25, a_scaler=1, d_scaler=1, r_scaler=1): #file=open(module_file_path, 'r')
    file=open(module_file_path, 'r')
    module=file.readlines()
    global soprano_freq
    global alto_freq
    global tenor_freq
    global bass_freq
    global soprano_dur
    global alto_dur
    global tenor_dur
    global bass_dur
    global soprano_dur_env
    global alto_dur_env
    global tenor_dur_env
    global bass_dur_env
    soprano_freq=[]
    alto_freq=[]
    tenor_freq=[]
    bass_freq=[]
    soprano_dur=[]
    alto_dur=[]
    tenor_dur=[]
    bass_dur=[]
    #soprano
    for dur in module:
        sp=dur.split('\t')
        if int(sp[0])==module_nr and int(sp[1])==1:
            #soprano_dur=np.append(soprano_dur, float(sp[5]))
            #soprano_freq=np.append(soprano_freq, musx.rescale(int(float(sp[4])), 65, 1056, bottom, ceiling))
            soprano_dur.append(float(sp[5]))
            #soprano_freq.append(musx.rescale(int(float(sp[4])), 65, 1056, bottom, ceiling))
            soprano_freq.append(rescale(int(float(sp[4])), 65, 1056, bottom, ceiling))
    #print("ilk sop", soprano_dur)
    #alto
    for dur in module:
        sp=dur.split('\t')
        if int(sp[0])==module_nr and int(sp[1])==2:
            alto_dur.append(float(sp[5]))
            #alto_freq.append(musx.rescale(int(float(sp[4])), 65, 1056, bottom, ceiling))
            alto_freq.append(rescale(int(float(sp[4])), 65, 1056, bottom, ceiling))
    #print("ilk alto", alto_dur)
            #alto_dur=np.append(alto_dur, float(sp[5]))
            #alto_freq=np.append(alto_freq, musx.rescale(int(float(sp[4])), 65, 1056, bottom, ceiling))
   #tenor
    for dur in module:
        sp=dur.split('\t')
        if int(sp[0])==module_nr and int(sp[1])==3:
            tenor_dur.append(float(sp[5]))
            #tenor_freq.append(musx.rescale(int(float(sp[4])), 65, 1056, bottom, ceiling))
            tenor_freq.append(rescale(int(float(sp[4])), 65, 1056, bottom, ceiling))
    #print("ilk tenor", tenor_dur)
    #bass
    for dur in module:
        sp=dur.split('\t')
        if int(sp[0])==module_nr and int(sp[1])==4:
            bass_dur.append(float(sp[5]))
            #bass_freq.append(musx.rescale(int(float(sp[4])), 65, 1056, bottom, ceiling))
            bass_freq.append(rescale(int(float(sp[4])), 65, 1056, bottom, ceiling))
    #print("ilk bass", bass_dur)

    #applies envelope on the longest part
    longest=return_shortest(soprano_dur, alto_dur, tenor_dur, bass_dur)
    longest_enveloped_in_beats=rhythm_enveloper_in_beats(longest, a_scaler, d_scaler, r_scaler)
    print("longest raw", longest, "scale factors", a_scaler, d_scaler, r_scaler, "longest env", longest_enveloped_in_beats)
    #longest_enveloped=concatenate(longest_enveloped)
    #longest_enveloped_in_beats=chop_in_beats(longest_enveloped)

    #rescale and align each part with longest enveloped part
    soprano_dur_env=[]
    chopped_soprano=chop_in_beats(soprano_dur)
    for x,y in zip(chopped_soprano, longest_enveloped_in_beats):
        #soprano_dur_env.append(musx.multiply(x,sum(y)))
        soprano_dur_env.append(quantize_list(list(map(lambda c: c* (sum(y)/sum(x)), x))))
        #print("sop x & y", x, y, "islem", (sum(y)/sum(x)))
    soprano_dur_env=concatenate(soprano_dur_env)
    soprano_dur_env=equalize(soprano_dur_env, sum(concatenate(longest_enveloped_in_beats)))
    print("chopped soprano", chopped_soprano, "sop", sum(soprano_dur_env), soprano_dur_env)

    alto_dur_env=[]
    chopped_alto=chop_in_beats(alto_dur)
    for x,y in zip(chopped_alto, longest_enveloped_in_beats):
        #alto_dur_env.append(musx.multiply(x,sum(y)))
        alto_dur_env.append(quantize_list(list(map(lambda c: c* (sum(y)/sum(x)), x))))
        #print("alt x & y", x, y, "islem", (sum(y)/sum(x)))
    alto_dur_env=concatenate(alto_dur_env)
    alto_dur_env=equalize(alto_dur_env, sum(concatenate(longest_enveloped_in_beats)))
    print("chopped alto", chopped_alto, "alto ", sum(alto_dur_env), alto_dur_env)

    tenor_dur_env=[]
    chopped_tenor=chop_in_beats(tenor_dur)
    for x,y in zip(chopped_tenor, longest_enveloped_in_beats):
        #tenor_dur_env.append(musx.multiply(x,sum(y)))
        tenor_dur_env.append(quantize_list(list(map(lambda c: c* (sum(y)/sum(x)), x))))
        #print("tenor x & y", x, y, "islem", (sum(y)/sum(x)))
    tenor_dur_env=concatenate(tenor_dur_env)
    tenor_dur_env=equalize(tenor_dur_env, sum(concatenate(longest_enveloped_in_beats)))
    print("chopped tenor", chopped_tenor, "tenor ", sum(tenor_dur_env), tenor_dur_env)

    bass_dur_env=[]
    chopped_bass=chop_in_beats(bass_dur)
    for x,y in zip(chopped_bass, longest_enveloped_in_beats):
        #bass_dur_env.append(musx.multiply(x,sum(y)))
        bass_dur_env.append(quantize_list(list(map(lambda c: c* (sum(y)/sum(x)), x))))
        #print("bass x & y", x, y, "islem", (sum(y)/sum(x)))
    bass_dur_env=concatenate(bass_dur_env)
    bass_dur_env=equalize(bass_dur_env, sum(concatenate(longest_enveloped_in_beats)))
    print("chopped bass", chopped_bass, "bass ", sum(bass_dur_env), bass_dur_env)


def module_process(in_dure=10, key=0, mode=3, floor=65, ceiling=1056, al_scaler=1, dl_scaler=1, rl_scaler=1, tempoo=100, title='June'):

    #s.tempo=tempoo
    time_sig_list=[]

    s.start_transcribing()

    if mode==4:
        mode='maj'
        print(in_dure, key, mode, floor, ceiling, al_scaler, dl_scaler, rl_scaler)
        get_wanted_module_num=get_module_w_len_key_mode(in_dure, key, mode)
        module_num_to_be_used=int(random.choice(get_wanted_module_num))
        print('module_num in use: ', module_num_to_be_used)
        import_process_beats_aligned("all_modules.txt", module_num_to_be_used,floor, ceiling, 0.25, al_scaler, dl_scaler, rl_scaler)
        time_sig=sechszehntelORachtelORviertel(reframe(bass_dur_env,3))
        time_sig_list.append(time_sig)
        print(time_sig)
        s.fork(p_soprano_part)
        s.fork(p_alto_part)
        s.fork(p_tenor_part)
        s.fork(p_bass_part)
        wait(sum(soprano_dur_env))

    if mode==3:
        mode='min'
        print(in_dure, key, mode, floor, ceiling, al_scaler, dl_scaler, rl_scaler)
        get_wanted_module_num=get_module_w_len_key_mode(in_dure, key, mode)
        module_num_to_be_used=int(random.choice(get_wanted_module_num))
        print('module_num in use: ', module_num_to_be_used)
        import_process_beats_aligned("all_modules.txt", module_num_to_be_used,floor, ceiling, 0.25, al_scaler, dl_scaler, rl_scaler)
        #numerator=str(int(quantize(sum(soprano_dur_env), 0.25)/0.25))
        #denominator=str(16)
        #time_sig=numerator+'/'+denominator
        time_sig=sechszehntelORachtelORviertel(reframe(bass_dur_env,3))
        time_sig_list.append(time_sig)
        print(time_sig)
        s.fork(p_soprano_part)
        s.fork(p_alto_part)
        s.fork(p_tenor_part)
        s.fork(p_bass_part)
        wait(sum(soprano_dur_env))
        #time.sleep(sum(soprano_dur_env))
    s.wait_for_children_to_finish()
    performance = s.stop_transcribing()
    performance.to_score(composer="Ayk", title="micro-state", time_signature=concatenate(time_sig_list), simplicity_preference=2).export_music_xml("outlet/fragment_"+title+".xml")


def module_process_fix_num(module_num=1, floor=65, ceiling=1056, al_scaler=1, dl_scaler=1, rl_scaler=1, title='Oct'):

    time_sig_list=[]

    s.start_transcribing()

    import_process_beats_aligned("all_modules.txt", module_num, floor, ceiling, 0.25, al_scaler, dl_scaler, rl_scaler)
    time_sig=sechszehntelORachtelORviertel(reframe(bass_dur_env,3))
    time_sig_list.append(time_sig)
    print(time_sig)
    s.fork(p_soprano_part)
    s.fork(p_alto_part)
    s.fork(p_tenor_part)
    s.fork(p_bass_part)
    wait(sum(soprano_dur_env))
    s.wait_for_children_to_finish()
    performance = s.stop_transcribing()
    performance.to_score(composer="Ayk", title="micro-state", time_signature=concatenate(time_sig_list), simplicity_preference=2).export_music_xml("fragmented"+title+".xml")

### check each module
### classify and write them to dictionaries according their key and mode.


major_key_dic={0:[], 1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[]}
minor_key_dic={0:[], 1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[]}

#def importt_select_process(module_file_path): #mode_code: 3=minor, 4=major
file=open("all_modules.txt", 'r')
module_lines=file.readlines()
first_module_num=0
last_module_num=module_lines[len(module_lines)-1].split('\t')[0]

previous=-1
current=0
out=[]

major_key_dic={0:[], 1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[]}
minor_key_dic={0:[], 1:[], 2:[], 3:[], 4:[], 5:[], 6:[], 7:[], 8:[], 9:[], 10:[], 11:[]}

#def importt_select_process(module_file_path): #mode_code: 3=minor, 4=major
file=open("all_modules.txt", 'r')
module_lines=file.readlines()
first_module_num=0
last_module_num=module_lines[len(module_lines)-1].split('\t')[0]
#print(last_module_num)

previous=-1
current=0
out=[]

for mod_line in module_lines:
    mode_line=mod_line.split('\t')
    #print(int(mod_line[7])==4)
    #print(int(mod_line[6]))
    current=mode_line[0]
    if current != previous:
        #print(current)
        if int(mode_line[7])==3:
            key=int(mode_line[6])
            length=get_module_length(module_lines, int(current))
            minor_key_dic[key].append((current, length))
            #print(current, key, mode_line[7])
            #out.append(current)
        if int(mode_line[7])==4:
            key=int(mode_line[6])
            length=get_module_length(module_lines, int(current))
            major_key_dic[key].append((current, length))
            #print(current, key, mode_line[7])
        #out.append(current)
        previous=current


""" before running make sure you have got the "all_modules.txt" file in the same directory """

"""
s = Session()
piano1 = s.new_part("Piano1")
piano2 = s.new_part("Piano2")
piano3 = s.new_part("Piano3")
piano4 = s.new_part("Piano4")
module_process(12, 5, 4, title="kfz-")
s.kill()
"""

"""
s = Session()
piano1 = s.new_part("Piano1")
piano2 = s.new_part("Piano2")
piano3 = s.new_part("Piano3")
piano4 = s.new_part("Piano4")
module_process_fix_num(module_num=600,bottom=56, ceiling=1856, title='XBerg-1')
s.kill()
"""



""" s = Session()
piano1 = s.new_part("Piano1")
piano2 = s.new_part("Piano2")
piano3 = s.new_part("Piano3")
piano4 = s.new_part("Piano4")
# module_process(12, 5, 4, title="kfz-")
module_process_fix_num(module_num=600,floor=56, ceiling=1856, title='XBerg-1')
s.kill()
"""
