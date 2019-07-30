From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH v10 3/5] overlayfs: add __get xattr method
Date: Tue, 30 Jul 2019 11:55:00 -0400
Message-ID: <e83ceef6-70ae-fd9e-2087-50baf2fbd402@tycho.nsa.gov>
References: <20190724195719.218307-1-salyzyn@android.com>
 <20190724195719.218307-4-salyzyn@android.com>
 <CAOQ4uxjizC1RhmLe3qmfASk2M-Y+QEiyLL1yJXa4zXAEby7Tig@mail.gmail.com>
 <af254162-10bf-1fc5-2286-8d002a287400@android.com>
 <CAOQ4uxi5S9HTx+wR1U_8vQ-6nyCozykWBZbZwiHhnXBGhXRz8Q@mail.gmail.com>
 <35b70147-25ad-4c29-3972-418ebee5e7b8@android.com>
 <CAOQ4uxg8k=4D5_VEBy61PwBo+2pCCakUPw3uCar2oQpi3yaLmA@mail.gmail.com>
 <f56cd45d-2926-094e-7f02-e2ca972214ba@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f56cd45d-2926-094e-7f02-e2ca972214ba@android.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@android.com, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 7/26/19 2:30 PM, Mark Salyzyn wrote:
> On 7/25/19 10:04 PM, Amir Goldstein wrote:
>> On Thu, Jul 25, 2019 at 7:22 PM Mark Salyzyn <salyzyn@android.com> wrote:
>>> On 7/25/19 8:43 AM, Amir Goldstein wrote:
>>>> On Thu, Jul 25, 2019 at 6:03 PM Mark Salyzyn <salyzyn@android.com> 
>>>> wrote:
>>>>> On 7/24/19 10:48 PM, Amir Goldstein wrote:
>>>>>> On Wed, Jul 24, 2019 at 10:57 PM Mark Salyzyn 
>>>>>> <salyzyn@android.com> wrote:
>>>>>>> Because of the overlayfs getxattr recursion, the incoming inode 
>>>>>>> fails
>>>>>>> to update the selinux sid resulting in avc denials being reported
>>>>>>> against a target context of u:object_r:unlabeled:s0.
>>>>>> This description is too brief for me to understand the root problem.
>>>>>> What's wring with the overlayfs getxattr recursion w.r.t the selinux
>>>>>> security model?
>>>>> __vfs_getxattr (the way the security layer acquires the target sid
>>>>> without recursing back to security to check the access permissions)
>>>>> calls get xattr method, which in overlayfs calls vfs_getxattr on the
>>>>> lower layer (which then recurses back to security to check 
>>>>> permissions)
>>>>> and reports back -EACCES if there was a denial (which is OK) and _no_
>>>>> sid copied to caller's inode security data, bubbles back to the 
>>>>> security
>>>>> layer caller, which reports an invalid avc: message for
>>>>> u:object_r:unlabeled:s0 (the uninitialized sid instead of the sid for
>>>>> the lower filesystem target). The blocked access is 100% valid, it is
>>>>> supposed to be blocked. This does however result in a cosmetic issue
>>>>> that makes it impossible to use audit2allow to construct a rule that
>>>>> would be usable to fix the access problem.
>>>>>
>>>> Ahhh you are talking about getting the security.selinux.* xattrs?
>>>> I was under the impression (Vivek please correct me if I wrong)
>>>> that overlayfs objects cannot have individual security labels and
>>> They can, and we _need_ them for Android's use cases, upper and lower
>>> filesystems.
>>>
>>> Some (most?) union filesystems (like Android's sdcardfs) set sepolicy
>>> from the mount options, we did not need this adjustment there of course.
>>>
>>>> the only way to label overlayfs objects is by mount options on the
>>>> entire mount? Or is this just for lower layer objects?
>>>>
>>>> Anyway, the API I would go for is adding a @flags argument to
>>>> get() which can take XATTR_NOSECURITY akin to
>>>> FMODE_NONOTIFY, GFP_NOFS, meant to avoid recursions.
>>> I do like it better (with the following 7 stages of grief below), best
>>> for the future.
>>>
>>> The change in this handler's API will affect all filesystem drivers
>>> (well, my change affects the ABI, so it is not as-if I saved the world
>>> from a module recompile) touching all filesystem sources with an even
>>> larger audience of stakeholders. Larger audience of stakeholders, the
>>> harder to get the change in ;-/. This is also concerning since I would
>>> like this change to go to stable 4.4, 4.9, 4.14 and 4.19 where this
>>> regression got introduced. I can either craft specific stable patches or
>>> just let it go and deal with them in the android-common distributions
>>> rather than seeking stable merged down. ABI/API breaks are a problem for
>>> stable anyway ...
>>>
>> Use the memalloc_nofs_save/restore design pattern will avoid all that
>> grief.
>> As a matter of fact, this issue could and should be handled inside 
>> security
>> subsystem without bothering any other subsystem.
>> LSM have per task context right? That context could carry the recursion
>> flags to know that the getxattr call is made by the security subsystem 
>> itself.
>> The problem is not limited to union filesystems.
>> In general its a stacking issue. ecryptfs is also a stacking fs, 
>> out-of-tree
>> shiftfs as well. But it doesn't end there.
>> A filesystem on top of a loop device inside another filesystem could
>> also maybe result in security hook recursion (not sure if in practice).
>>
>> Thanks,
>> Amir.
> 
> Good point, back to Stephen Smalley?
> 
> There are four __vfs_getxattr calls inside security, not sure I see any 
> natural way to determine the recursion in security/selinux I can 
> beg/borrow/steal from; but I get the strange feeling that it is better 
> to detect recursion in __vfs_getxattr in this manner, and switch out 
> checking in vfs_getxattr since it is localized to just fs/xattr.c. 
> selinux might not be the only user of __vfs_getxattr nature ...
> 
> I have implemented and tested the solution where we add a flag to the 
> .get method, it works. I would be tempted to submit that instead in case 
> someone in the future can imagine using that flag argument to solve 
> other problem(s) (if you build it, they will come).
> 
> <flips coin>
> 
> Will add a new per-process flag that __vfs_getxattr and vfs_getxattr 
> plays with and see how it works and what it looks like.

As you say, SELinux is not the only user of __vfs_getxattr; in addition 
to the other security modules, there is the integrity/evm subsystem and 
ecryptfs.  Further, __vfs_getxattr does not merely skip 
LSM/SELinux-related processing; it also skips xattr_permission().  As 
such, I don't believe this is something that can be solved entirely 
within the security subsystem.

Not excited about a process flag to implicitly disable LSM/SELinux and 
other security-related processing on a code path; potential for abuse is 
high.
