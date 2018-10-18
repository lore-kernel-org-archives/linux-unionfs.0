Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <f6de5a77786759a7308ec8dc6cfe41c6@agner.ch> <CAJfpegvn9pXJ9EULD-+HXJJNkH58CSB5TEhpv3udHFo47BqeNQ@mail.gmail.com>
 <CAOQ4uxgcsHXZ3ctE1NNMey_y_LNagtx_n+Tdq7SApT6EgLsd0Q@mail.gmail.com>
 <CAJfpegsAvjfixdO9iRDsV2XwvGaQS9GpbBdkKnkxJS=3ghcZ-g@mail.gmail.com>
 <CAOQ4uxjqmQJmE5xLfqJGCnZoMf6NPtcNso7Fotjy_hGAUObK+w@mail.gmail.com> <b9f68a97417b5d907e8e882b9e8d19a1@agner.ch>
In-Reply-To: <b9f68a97417b5d907e8e882b9e8d19a1@agner.ch>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 18 Oct 2018 17:34:58 +0300
Message-ID: <CAOQ4uxjAuEthHhDHMjZQ2BVbk0n3Xq-Sd-UfgkGGFfYKeRKWnQ@mail.gmail.com>
Subject: Re: WARNING: possible recursive locking detected in mnt_want_write/mnt_want_write_file_path
Content-Type: text/plain; charset="UTF-8"
To: stefan@agner.ch
Cc: Miklos Szeredi <miklos@szeredi.hu>, Sasha Levin <alexander.levin@microsoft.com>, overlayfs <linux-unionfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 18, 2018 at 4:25 PM Stefan Agner <stefan@agner.ch> wrote:
>
> On 18.10.2018 13:50, Amir Goldstein wrote:
> > On Wed, Oct 17, 2018 at 9:37 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >>
> >> On Wed, Oct 17, 2018 at 5:24 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> >> > Miklos,
> >> >
> >> > You must have confused "the algorithm" by including a "fix" commit in
> >> > rc1 pull request
> >> > without mentioning that it "Fixes" a commit in the same pull request.
> >>
> >> I didn't know there were heuristics other than "Cc: stable@.."
> >>
> >
> > Yes. Given a Fixes: label, I bet Cc: stable is not needed to auto select
> > for stable??
>
> Given a Fixes: probably would prevented it to be selected since the
> commit it references is not part of 4.18...
>

Indeed. adding a Fixes label for non-stable patches as well would be
good practice.

Thanks,
Amir.
