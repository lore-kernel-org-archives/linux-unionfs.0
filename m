From: Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: 45aebeaf4f67 "ovl: Ensure upper filesystem supports d_type"
 breaking Docker
Date: Tue, 17 May 2016 10:15:21 +0200
Message-ID: <CAOssrKejFhkVssL19uXQnfuEMfP8CXNPMHNGq0_3yazPOk+Xpg@mail.gmail.com>
References: <87d1ombix6.fsf@gamma.ozlabs.ibm.com>
	<20160516130727.GA26411@redhat.com>
	<20160517062829.GG14480@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160517062829.GG14480@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Vivek Goyal <vgoyal@redhat.com>, Daniel Axtens <dja@axtens.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, mpe@ellerman.id.au, dchinner@redhat.com
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 17, 2016 at 8:28 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, May 16, 2016 at 09:07:27AM -0400, Vivek Goyal wrote:
>> So it became clear that we need a check at mount time to make sure
>> d_type is supported otherwise error out. This will require users to
>> do mkfs.xfs with ftype=1 to make progress.
>>
>> I think new defaults for mkfs.xfs are such that ftype=1 is set. I am
>> not sure which version that change was made in.
>
> Dumb question - can we end up with empty workdir at that point?  Because
> if we do, the check would appear to return a false negative, no matter
> what fs supports...

ovl_workdir_create() creates a subdirectory of workdir ("work") so
workdir itself won't be empty after that.  If somebody else messes
with workdir, then we are screwed anyway.

Thanks,
Miklos
