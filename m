From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2] ovl: update S_ISGID when setting posix ACLs
Date: Fri, 28 Oct 2016 07:47:12 +0300
Message-ID: <CAOQ4uxiSf+9u0P1s5--uj19ubrJYrUWH_WM2FPbpvH9yApoZyQ@mail.gmail.com>
References: <1477501840-25066-1-git-send-email-amir73il@gmail.com>
 <1477506616-14061-1-git-send-email-amir73il@gmail.com> <20161027223742.GC4819@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32998 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751401AbcJ1ErP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Oct 2016 00:47:15 -0400
In-Reply-To: <20161027223742.GC4819@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Oct 28, 2016 at 1:37 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Oct 26, 2016 at 09:30:16PM +0300, Amir Goldstein wrote:
>> Since operations on upper are performed using mounter's credentials,
>> we need to call posix_acl_update_mode() with current credentials on
>> overlay inode to possibly copy-up and clear setgid bit, before setting
>> posix ACLs on upper inode.
>>
>> Also wrap posix acl handlers with #ifdef CONFIG_FS_POSIX_ACL to
>> avoid compiler warning for implicit declaration of function
>> 'posix_acl_update_mode' on build without that config option.
>>
>> This change fixes xfstest generic/375, which failed to clear the
>> setgid bit in the following test case over overlayfs:
>>
>>   touch $testfile
>>   chown 100:100 $testfile
>>   chmod 2755 $testfile
>>   _runas -u 100 -g 101 -- setfacl -m u::rwx,g::rwx,o::rwx $testfile
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/super.c | 31 +++++++++++++++++++++++++++++++
>>  1 file changed, 31 insertions(+)
>>
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 30263a5..7071790 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -523,6 +523,22 @@ static unsigned int ovl_split_lowerdirs(char *str)
>>  }
>>
>>  static int __maybe_unused
>> +ovl_set_mode(struct dentry *dentry, umode_t mode)
>> +{
>> +     struct iattr iattr;
>> +
>> +     if (mode == d_inode(dentry)->i_mode)
>> +             return 0;
>> +
>> +     iattr.ia_valid = ATTR_MODE | ATTR_CTIME;
>> +     iattr.ia_mode = mode;
>> +     iattr.ia_ctime = current_time(d_inode(dentry));
>> +
>> +     return ovl_setattr(dentry, &iattr);
>> +}
>> +
>> +#ifdef CONFIG_FS_POSIX_ACL
>> +static int __maybe_unused
>>  ovl_posix_acl_xattr_get(const struct xattr_handler *handler,
>>                       struct dentry *dentry, struct inode *inode,
>>                       const char *name, void *buffer, size_t size)
>> @@ -560,6 +576,18 @@ ovl_posix_acl_xattr_set(const struct xattr_handler *handler,
>>       if (!inode_owner_or_capable(inode))
>>               goto out_acl_release;
>>
>> +     if (handler->flags == ACL_TYPE_ACCESS) {
>> +             umode_t mode;
>> +             struct posix_acl *newacl = acl;
>> +
>> +             err = posix_acl_update_mode(inode, &mode, &newacl);
>> +             if (err)
>> +                     goto out_acl_release;
>> +             err = ovl_set_mode(dentry, mode);
>> +             if (err)
>> +                     goto out_acl_release;
>> +     }
>> +
>>       posix_acl_release(acl);
>>
>>       err = ovl_xattr_set(dentry, handler->name, value, size, flags);
>> @@ -572,6 +600,7 @@ ovl_posix_acl_xattr_set(const struct xattr_handler *handler,
>
> Hi Amir,
>
> What happens if ovl_set_mode() is successful but ovl_xattr_set() fails. We
> will leave file with S_ISGID clear?
>

Yes, we will, and that is the same thing that both xfs and ext4 do.
We already tested that current user has sufficient credentials to perform
the operation (and some other validity checks). IMO, if user has the right to
perform an operation with the knowledge that this operation will clear S_ISGID
and user executes this operation, then at least from security point of view, the
outcome of clearing the bit even though the operation itself failed makes sense.

Thanks,
Amir.
