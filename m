From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH 19/35] ovl: readd reflink/copyfile/dedup support
Date: Thu, 3 May 2018 22:48:58 +0300
Message-ID: <CAOQ4uxjkf4Sv4c56HLTxuSov4eFqskhyv9V1Q_OAz4pp1GqpHA@mail.gmail.com>
References: <20180412150826.20988-1-mszeredi@redhat.com> <20180412150826.20988-20-mszeredi@redhat.com>
 <CAOQ4uxjKJHnM_ad9TnyQ8i0fUjEqCEG8ocPAs_L0oSraKhSEPA@mail.gmail.com> <CAOssrKd+EjBYWMmGxVSCKQmFWhBf99eic4XLJ0YhZu3r0Kad5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOssrKd+EjBYWMmGxVSCKQmFWhBf99eic4XLJ0YhZu3r0Kad5g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, May 3, 2018 at 7:04 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
> On Tue, Apr 17, 2018 at 10:31 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Thu, Apr 12, 2018 at 6:08 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>>> Since set of arguments are so similar, handle in a common helper.
>>>
>>> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
>>> ---
>>>  fs/overlayfs/file.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 79 insertions(+)
>>>
>>> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
>>> index 9670e160967e..39b1b73334ad 100644
>>> --- a/fs/overlayfs/file.c
>>> +++ b/fs/overlayfs/file.c
>>> @@ -352,6 +352,81 @@ long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>>>         return ret;
>>>  }
>>>
>>> +enum ovl_copyop {
>>> +       OVL_COPY,
>>> +       OVL_CLONE,
>>> +       OVL_DEDUPE,
>>> +};
>>> +
>>> +static ssize_t ovl_copyfile(struct file *file_in, loff_t pos_in,
>>> +                           struct file *file_out, loff_t pos_out,
>>> +                           u64 len, unsigned int flags, enum ovl_copyop op)
>>> +{
>>> +       struct inode *inode_out = file_inode(file_out);
>>> +       struct fd real_in, real_out;
>>> +       const struct cred *old_cred;
>>> +       int ret;
>>> +
>>> +       ret = ovl_real_file(file_out, &real_out);
>>> +       if (ret)
>>> +               return ret;
>>> +
>>> +       ret = ovl_real_file(file_in, &real_in);
>>> +       if (ret) {
>>> +               fdput(real_out);
>>> +               return ret;
>>> +       }
>>> +
>>> +       old_cred = ovl_override_creds(file_inode(file_out)->i_sb);
>>> +       switch (op) {
>>> +       case OVL_COPY:
>>> +               ret = vfs_copy_file_range(real_in.file, pos_in,
>>> +                                         real_out.file, pos_out, len, flags);
>>
>> Problem:
>> vfs_copy_file_range(ovl_lower_file, ovl_upper_file) on non samefs
>> will get -EXDEV from  ovl_copy_file_range(), so will not fall back
>> to do_splice_direct().
>
> This is not a regression, right?

Right.

>
>> We may be better off checking in_sb != out_sb and returning
>> -EOPNOTSUPP? not sure.
>
> I think we should fix vfs_copy_file_range() to fall back to copying if
> not on the same fs.   Not sure why it doesn't do that now.
>

There seems to be a posting to fix that as we speak...

I seem to recall some flames from hch about a similar change
that NFS folks where trying to push for. Let's see how this one goes.


>>
>>
>>> +               break;
>>> +
>>> +       case OVL_CLONE:
>>> +               ret = vfs_clone_file_range(real_in.file, pos_in,
>>> +                                          real_out.file, pos_out, len);
>>> +               break;
>>> +
>>> +       case OVL_DEDUPE:
>>> +               ret = vfs_dedupe_file_range_one(real_in.file, pos_in, len,
>>> +                                               real_out.file, pos_out);
>>
>> Problem:
>> real_out can be a readonly fd (for is_admin), so we will be deduping
>> the lower file.
>
> Ugh...
>
>> I guess this problem is mitigated in current code by may_write_real().
>>
>> How can we deal with that sort of "write leak" without patching
>>  mnt_want_write_file()?
>
> We need to check before calling dedupe on real files that both are on upper.
>
> My problem is what error code to return.  Neither EXDEV nor EINVAL
> descibe the error adequately.  It should be "We could dedupe if we
> really wanted to, but it makes no sense to do so"...  So now it
> returns -EBADE, which means "data was different", but at least that
> one should at least be expected by callers.
>

EPERM  dest_fd is immutable

Which exactly what may_write_real() returns today.

Thanks,
Amir.
