From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: [PATCH] ovl: filter of trusted xattr results in audit
Date: Mon, 7 Oct 2019 09:42:08 -0700
Message-ID: <7c610f92-5e1f-32ef-0a60-ed47ea999fe3@android.com>
References: <20191007160918.29504-1-salyzyn@android.com>
 <20191007161616.GA988623@kroah.com> <20191007161725.GB988623@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191007161725.GB988623@kroah.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-team@android.com, linux-security-module@vger.kernel.org, stable@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 10/7/19 9:17 AM, Greg Kroah-Hartman wrote:
> On Mon, Oct 07, 2019 at 06:16:16PM +0200, Greg Kroah-Hartman wrote:
>> On Mon, Oct 07, 2019 at 09:09:16AM -0700, Mark Salyzyn wrote:
>>> When filtering xattr list for reading, presence of trusted xattr
>>> results in a security audit log.  However, if there is other content
>>> no errno will be set, and if there isn't, the errno will be -ENODATA
>>> and not -EPERM as is usually associated with a lack of capability.
>>> The check does not block the request to list the xattrs present.
>>>
>>> Switch to has_capability_noaudit to reflect a more appropriate check.
>>>
>>> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
>>> Cc: linux-security-module@vger.kernel.org
>>> Cc: kernel-team@android.com
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Cc: stable@vger.kernel.org # v3.18
>>> Fixes: upstream a082c6f680da ("ovl: filter trusted xattr for non-admin")
>>> Fixes: 3.18 4bcc9b4b3a0a ("ovl: filter trusted xattr for non-admin")
>>> ---
>>> Replaced ns_capable_noaudit with 3.18.y tree specific
>>> has_capability_noaudit present in original submission to kernel.org
>>> commit 5c2e9f346b815841f9bed6029ebcb06415caf640
>>> ("ovl: filter of trusted xattr results in audit")
>>>
>>>   fs/overlayfs/inode.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
>>> index a01ec1836a72..1175efa5e956 100644
>>> --- a/fs/overlayfs/inode.c
>>> +++ b/fs/overlayfs/inode.c
>>> @@ -265,7 +265,8 @@ static bool ovl_can_list(const char *s)
>>>   		return true;
>>>   
>>>   	/* Never list trusted.overlay, list other trusted for superuser only */
>>> -	return !ovl_is_private_xattr(s) && capable(CAP_SYS_ADMIN);
>>> +	return !ovl_is_private_xattr(s) &&
>>> +	       has_capability_noaudit(current, CAP_SYS_ADMIN);
>>>   }
>>>   
>>>   ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
>>> -- 
>>> 2.23.0.581.g78d2f28ef7-goog
>>>
>> Thanks for the backport, this one worked!
> I spoke too soon:
>
> ERROR: "has_capability_noaudit" [fs/overlayfs/overlay.ko] undefined!
>
> That function isn't exported for modules :(
>
> greg k-h

<sigh>

Now what is the playbook, we have three options in order of preference:

1) #ifdef MODULE use capable() to preserve API, add a short comment 
about the side effects if overlayfs is used as a module.

2) export has_capability_nodaudit (proc and oom_kill use it, and are 
both built-in only), but affect the 3.18 API at near EOL. AFAIK no one 
wants that?

3) Do nothing more. Make this a distro concern only. Leave this posted 
as a back-port for the record, but never merged, for those that are 
_interested_ and declare 3.18 stable as noisy for sepolicy and overlayfs 
under some usage patterns with few user space mitigation unless they 
explicitly take this back-port into their tree (eg: android common 
kernel) if used built-in. This way, in 3.18.y at least the module and 
built-in version behave the _same_ in stable.

Looking for feedback.

Sincerely -- Mark Salyzyn
