From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [POC/RFC PATCH] overlayfs: fix data inconsistency at copy up
Date: Fri, 21 Oct 2016 11:53:41 +0300
Message-ID: <CAOQ4uxh7cfh5ZtNX8hkeTuye6hRxbMpzZ4p9mGAn2z5rq3RGvA@mail.gmail.com>
References: <20161012133326.GD31239@veci.piliscsaba.szeredi.hu>
 <20161020204630.GA1000@redhat.com> <20161020205408.GB1000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161020205408.GB1000@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jeremy Eder <jeder@redhat.com>, David Howells <dhowells@redhat.com>, Ratna Bolla <rbolla@portworx.com>, Gou Rao <grao@portworx.com>, Vinod Jayaraman <jv@portworx.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Oct 20, 2016 at 11:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Oct 20, 2016 at 04:46:30PM -0400, Vivek Goyal wrote:
>
> [..]
>> > +static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *to)
>> > +{
>> > +   struct file *file = iocb->ki_filp;
>> > +   bool isupper = OVL_TYPE_UPPER(ovl_path_type(file->f_path.dentry));
>> > +   ssize_t ret = -EINVAL;
>> > +
>> > +   if (likely(!isupper)) {
>> > +           const struct file_operations *fop = ovl_real_fop(file);
>> > +
>> > +           if (likely(fop->read_iter))
>> > +                   ret = fop->read_iter(iocb, to);
>> > +   } else {
>> > +           struct file *upperfile = filp_clone_open(file);
>> > +
>>
>> IIUC, every read of lower file will call filp_clone_open(). Looking at the
>> code of filp_clone_open(), I am concerned about the overhead of this call.
>> Is it significant? Don't want to be paying too much of penalty for read
>> operation on lower files. That would be a common case for containers.
>>
>
> Looks like I read the code in reverse. So if I open a file read-only,
> and if it has not been copied up, I will simply call read_iter() on
> lower filesystem. But if file has been copied up, then I will call
> filp_clone_open() and pay the cost. And this will continue till this
> file is closed by caller.
>

I wonder if that cost could be reduced by calling replace_fd() or
some variant of it to install the cloned file onto the rofd after the
first access??

> When file is opened again, by that time it is upper file and we will
> install real fop in file (instead of overlay fop).
>
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
