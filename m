From: Daniel Axtens <dja@axtens.net>
Subject: Re: 45aebeaf4f67 "ovl: Ensure upper filesystem supports d_type" breaking Docker
Date: Wed, 18 May 2016 13:33:13 +1000
Message-ID: <87eg906nwm.fsf@gamma.ozlabs.ibm.com>
References: <87d1ombix6.fsf@gamma.ozlabs.ibm.com> <20160516130727.GA26411@redhat.com> <20160517062829.GG14480@ZenIV.linux.org.uk> <CAOssrKejFhkVssL19uXQnfuEMfP8CXNPMHNGq0_3yazPOk+Xpg@mail.gmail.com> <20160517121023.GA6553@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160517121023.GA6553@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, mpe@ellerman.id.au, dchinner@redhat.com
List-Id: linux-unionfs@vger.kernel.org

Hi Vivek,

My sincere apologies - it turns out I *was* running on xfs with
ftype=0. Someone in the office had moved docker's storage without
me noticing.

Apologies to all whose time I wasted.

Regards,
Daniel

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, May 17, 2016 at 10:15:21AM +0200, Miklos Szeredi wrote:
>> On Tue, May 17, 2016 at 8:28 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > On Mon, May 16, 2016 at 09:07:27AM -0400, Vivek Goyal wrote:
>> >> So it became clear that we need a check at mount time to make sure
>> >> d_type is supported otherwise error out. This will require users to
>> >> do mkfs.xfs with ftype=1 to make progress.
>> >>
>> >> I think new defaults for mkfs.xfs are such that ftype=1 is set. I am
>> >> not sure which version that change was made in.
>> >
>> > Dumb question - can we end up with empty workdir at that point?  Because
>> > if we do, the check would appear to return a false negative, no matter
>> > what fs supports...
>> 
>> ovl_workdir_create() creates a subdirectory of workdir ("work") so
>> workdir itself won't be empty after that.  If somebody else messes
>> with workdir, then we are screwed anyway.
>
> Right. Initially I was creating a directory of my own and later realized
> that ovl_workdir_create() already creates one.
>
> Having said that, what happens when ovl_workdir_create() fails and we
> mount overlayfs read only. In that case I think we will conclude that
> underlying fs does not support d_type and mounting will fail.
>
> Any thoughts, on how to handle this failure path better?
>
> Daniel,
>
> Yesterday Eric Sandeen told me that I can run "xfs_info <mount-point>" to
> figure out if ftype is 0 or 1. You might want to run "xfs_info /" and 
> ensure ftype=0 in your case and overlay is not detecting it wrong.
>
> Thanks
> Vivek
