From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: [PATCH v10 3/5] overlayfs: add __get xattr method
Date: Thu, 25 Jul 2019 08:03:13 -0700
Message-ID: <af254162-10bf-1fc5-2286-8d002a287400@android.com>
References: <20190724195719.218307-1-salyzyn@android.com>
 <20190724195719.218307-4-salyzyn@android.com>
 <CAOQ4uxjizC1RhmLe3qmfASk2M-Y+QEiyLL1yJXa4zXAEby7Tig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxjizC1RhmLe3qmfASk2M-Y+QEiyLL1yJXa4zXAEby7Tig@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@android.com, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 7/24/19 10:48 PM, Amir Goldstein wrote:
> On Wed, Jul 24, 2019 at 10:57 PM Mark Salyzyn <salyzyn@android.com> wrote:
>> Because of the overlayfs getxattr recursion, the incoming inode fails
>> to update the selinux sid resulting in avc denials being reported
>> against a target context of u:object_r:unlabeled:s0.
> This description is too brief for me to understand the root problem.
> What's wring with the overlayfs getxattr recursion w.r.t the selinux
> security model?

__vfs_getxattr (the way the security layer acquires the target sid 
without recursing back to security to check the access permissions) 
calls get xattr method, which in overlayfs calls vfs_getxattr on the 
lower layer (which then recurses back to security to check permissions) 
and reports back -EACCES if there was a denial (which is OK) and _no_ 
sid copied to caller's inode security data, bubbles back to the security 
layer caller, which reports an invalid avc: message for 
u:object_r:unlabeled:s0 (the uninitialized sid instead of the sid for 
the lower filesystem target). The blocked access is 100% valid, it is 
supposed to be blocked. This does however result in a cosmetic issue 
that makes it impossible to use audit2allow to construct a rule that 
would be usable to fix the access problem.

This problem would exist for any (in tree or out-of-tree) union 
filesystems that need to reflect the __vfs_getxattr call into a 
__vfs_getxattr call to the underlying filesystem.

>
> Please give an example of your unprivileged mounter use case
> to explain.

The mounter merely does not have access to the targets in one of the 
referenced filesystems (for override creds = on)

In Android would be init, it does not have access to a subset of 
u:object_r:*_exec:s0 and u::objects_r:vendor*:s0 labels. Based on a need 
to access basis.

This gets worse if we add override creds = off, because the multitude of 
callers could be denied access, and rightfully so, and we would have no 
clue how to construct rules to grant them permissions using standard 
tools like audit2allow.

I will figure out how to explain this in the commit message ... but do 
tell me if I did not 'connect' you to the underlying problem so I can 
make it clear to _everyone_.

>
> CC Vivek because I could really never understand all this.
>
>> Solution is to add a _get xattr method that calls the __vfs_getxattr
>> handler so that the context can be read in, rather than being denied
>> with an -EACCES when vfs_getxattr handler is called.
>> . . .
>> @@ -972,6 +989,7 @@ static const struct xattr_handler ovl_own_xattr_handler = {
>>   static const struct xattr_handler ovl_other_xattr_handler = {
>>          .prefix = "", /* catch all */
>>          .get = ovl_other_xattr_get,
>> +       .__get = __ovl_other_xattr_get,
>>          .set = ovl_other_xattr_set,
>>   };
>>
>
> Not very professional of me to comment on the proposed solution
> without understanding the problem, but my nose says this cannot
> be the right solution and if it is, then you better find a much better
> name for the API then __get() and document it properly.

Yes __get (instead of the existing get which checks sepolicy) was my 
idea. get_wo_security was a close alternative.

We worked through 5 "solutions", this one privately appeared to please 
the security folks. In fact the solution was their suggestion because 
they noticed that __vfs_getxattr was meant to bypass sepolicy checking, 
yet when nested through overlayfs, it called vfs_getxattr for the lower 
filesystems and blocked necessary content (sid actually) from the upper 
call in order to properly log the denial. I had originally copied just 
the sid to the upper caller by adding layering violations that creeped 
them out ;-/
