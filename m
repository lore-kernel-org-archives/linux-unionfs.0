Return-Path: <vgoyal@redhat.com>
Date: Fri, 26 Oct 2018 10:16:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] overlayfs: Return error if metadata only copy-up can't
 be enabled
Message-ID: <20181026141640.GC17321@redhat.com>
References: <20181026134333.GB17321@redhat.com>
 <CAJfpegu+0iX3BcEXAPQVRpcAWOgyROOT9+Ng92rTp_=1gCBgtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegu+0iX3BcEXAPQVRpcAWOgyROOT9+Ng92rTp_=1gCBgtg@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Daniel J Walsh <dwalsh@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Oct 26, 2018 at 04:10:27PM +0200, Miklos Szeredi wrote:
> On Fri, Oct 26, 2018 at 3:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Assume a user wanted to enable metadata only copy-up and passes metacopy=on.
> > If this feature can't be enabled, we disable metacopy=off and just leave
> > a warning in logs. metacopy=on requires redirect_dir=on (for upper dir)
> > or redirect_dir=follow (for non-upper mount).
> 
> What's the reason we can't enable these for metacopy=on automatically?
> 
> I mean, the simplest and least surprising behavior would be if
> metacopy would simply imply redirect_dir, no?

redirect_dir=on is a significant change. And it might be better if
users passes it in (instead of enabling it automatically).

For example, when redirect_dir is enabled, container runtime software
(docker, podman), their logic to generate image does not work and
they have to fall back to *slower* method of diff.

https://github.com/moby/moby/pull/34342

IOW, enabling redirect_dir automatically has performance implications
for container image building process. Given that, it might be better
to fail and let user conciously make that choise and in the process
understand that there can be downsides to enabling metacopy.

But I am not very particular about it. Automatically enabling redirect_dir
sounds better than disabling metacopy automatically.

Thanks
Vivek
