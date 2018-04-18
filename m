From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH 31/35] Revert "vfs: add d_real_inode() helper"
Date: Wed, 18 Apr 2018 15:49:02 +0200
Message-ID: <CAJfpeguJN0+m9Vhtv0fo79xq-P1UzWki9GqQq9WyJRMEwiJBqQ@mail.gmail.com>
References: <20180412150826.20988-1-mszeredi@redhat.com> <20180412150826.20988-32-mszeredi@redhat.com>
 <CAOQ4uxgdWCWvwWgjUu06H=BeMxh-BVAjxVE5Ckj-poKRGgwvMQ@mail.gmail.com>
 <CAJfpegtLdmnxieDx7+FBUoc-fKsTEwA+oHinhAfa4E9SDFfSNw@mail.gmail.com> <20180418093845.19ca33f3@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180418093845.19ca33f3@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Howard McLauchlan <hmclauchlan@fb.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Apr 18, 2018 at 3:38 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 18 Apr 2018 13:42:03 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> On Wed, Apr 18, 2018 at 10:19 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> > On Thu, Apr 12, 2018 at 6:08 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>> >> This reverts commit a118084432d642eeccb961c7c8cc61525a941fcb.
>> >>
>> >> No user of d_real_inode() remains, so it can be removed.
>> >>
>> >
>> > FYI, there is a new user in v4.17-rc1 added by commit
>> > f0a2aa5a2a40 tracing/uprobe: Add support for overlayfs
>> >
>> > Seems like this patch got merged without any CC to overlayfs
>> > mailing list nor maintainer?
>
> It appeared to be a small change with lots of reviewers. I didn't think
> it was something to notify the overlayfs folks with. But perhaps I was
> wrong.

The patch is correct.  The code surrounding it isn't, though.

>
>> >
>> > Not sure yet if overlayfs-rorw patches would allow reverting this
>> > change.
>>
>> Not trivial, because uprobe is looking at i_mapping to get a list of
>> current memory maps.   We could set i_mapping at overlay inode
>> initialization time, but we definitely can't *change* i_mapping at
>> copy up.  Which is bound to result in some weird inconsistencies.  So
>> likely we'll need to keep d_real_inode() for the time being.
>
> I just received this patch:
>
>  http://lkml.kernel.org/r/20180418062907.3210386-1-songliubraving@fb.com
>
> Which removes this code. Can you review it and I'll take it.

It shouldn't remove d_real_inode(), because that part is correct and
fixes a real bug in handling overlayfs files.

I'll review, but apparently I wasn't CC-d on that patch.   Weird.

Thanks,
Miklos
