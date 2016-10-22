From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [POC/RFC PATCH] overlayfs: fix data inconsistency at copy up
Date: Sat, 22 Oct 2016 18:39:19 +0300
Message-ID: <CAOQ4uxjzdhfC06gNmNNWweQ=r28TvK36Synt+jvPd2HM+wLTOw@mail.gmail.com>
References: <20161012133326.GD31239@veci.piliscsaba.szeredi.hu>
 <20161020204630.GA1000@redhat.com> <20161020205408.GB1000@redhat.com>
 <CAOQ4uxh7cfh5ZtNX8hkeTuye6hRxbMpzZ4p9mGAn2z5rq3RGvA@mail.gmail.com>
 <20161021201335.GB20129@redhat.com> <CAOQ4uxiH6-JQcwSqvBcSaVzm5V5iyo4V5DWSxc1LH3aZPAvBEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36490 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934425AbcJVPjW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 22 Oct 2016 11:39:22 -0400
In-Reply-To: <CAOQ4uxiH6-JQcwSqvBcSaVzm5V5iyo4V5DWSxc1LH3aZPAvBEA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jeremy Eder <jeder@redhat.com>, David Howells <dhowells@redhat.com>, Gou Rao <grao@portworx.com>, Vinod Jayaraman <jv@portworx.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>

On Sat, Oct 22, 2016 at 10:24 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Oct 21, 2016 at 11:13 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Fri, Oct 21, 2016 at 11:53:41AM +0300, Amir Goldstein wrote:
>>> On Thu, Oct 20, 2016 at 11:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>> > On Thu, Oct 20, 2016 at 04:46:30PM -0400, Vivek Goyal wrote:
>>> >
>>> > [..]
>>> >> > +static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>> >> > +{
>>> >> > +   struct file *file = iocb->ki_filp;
>>> >> > +   bool isupper = OVL_TYPE_UPPER(ovl_path_type(file->f_path.dentry));
>>> >> > +   ssize_t ret = -EINVAL;
>>> >> > +
>>> >> > +   if (likely(!isupper)) {
>>> >> > +           const struct file_operations *fop = ovl_real_fop(file);
>>> >> > +
>>> >> > +           if (likely(fop->read_iter))
>>> >> > +                   ret = fop->read_iter(iocb, to);
>>> >> > +   } else {
>>> >> > +           struct file *upperfile = filp_clone_open(file);
>>> >> > +
>>> >>
>>> >> IIUC, every read of lower file will call filp_clone_open(). Looking at the
>>> >> code of filp_clone_open(), I am concerned about the overhead of this call.
>>> >> Is it significant? Don't want to be paying too much of penalty for read
>>> >> operation on lower files. That would be a common case for containers.
>>> >>
>>> >
>>> > Looks like I read the code in reverse. So if I open a file read-only,
>>> > and if it has not been copied up, I will simply call read_iter() on
>>> > lower filesystem. But if file has been copied up, then I will call
>>> > filp_clone_open() and pay the cost. And this will continue till this
>>> > file is closed by caller.
>>> >
>>>
>>> I wonder if that cost could be reduced by calling replace_fd() or
>>> some variant of it to install the cloned file onto the rofd after the
>>> first access??
>>
>> Hmm.., Interesting. Will something like following work? This applies on
>> top of Miklos's patch. It seems to work for me. It might be completely
>> broken/racy though. Somebody who understands this code well, will have
>> to have a look.
>>
>
> The idea sounded scary already when I suggested it :)
> See below what I think is scary about this implementation...
>
> Thanks for following through.
>
>
>> ---
>>  fs/file.c            |   41 +++++++++++++++++++++++++++++++++++++++++
>>  fs/overlayfs/inode.c |    1 +
>>  2 files changed, 42 insertions(+)
>>
>> Index: rhvgoyal-linux/fs/overlayfs/inode.c
>> ===================================================================
>> --- rhvgoyal-linux.orig/fs/overlayfs/inode.c    2016-10-21 15:43:05.391488406 -0400
>> +++ rhvgoyal-linux/fs/overlayfs/inode.c 2016-10-21 16:07:57.409420795 -0400
>> @@ -416,6 +416,7 @@ static ssize_t ovl_read_iter(struct kioc
>>                 if (IS_ERR(upperfile)) {
>>                         ret = PTR_ERR(upperfile);
>>                 } else {
>> +                       replace_file(file, upperfile);
>
> When fdtable is not shared (single threaded process), after this call
> I think that file pointer
> may be free (?), because file is not reference counted.
> Although I did not see any code in VFS callers trying to dereference
> the file pointer after
> calling read_iter(), this seems like a dangerous practice, so will
> need to a way to fix that.
>

My bad. file pointer is freed in work_task_run(), so replace_file()
should be just as safe as replace_fd() and do_dup2().
