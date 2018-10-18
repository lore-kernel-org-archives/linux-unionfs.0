Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw1-f45.google.com ([209.85.161.45]:42548 "EHLO
        mail-yw1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbeJRTvL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Oct 2018 15:51:11 -0400
MIME-Version: 1.0
References: <f6de5a77786759a7308ec8dc6cfe41c6@agner.ch> <CAJfpegvn9pXJ9EULD-+HXJJNkH58CSB5TEhpv3udHFo47BqeNQ@mail.gmail.com>
 <CAOQ4uxgcsHXZ3ctE1NNMey_y_LNagtx_n+Tdq7SApT6EgLsd0Q@mail.gmail.com> <CAJfpegsAvjfixdO9iRDsV2XwvGaQS9GpbBdkKnkxJS=3ghcZ-g@mail.gmail.com>
In-Reply-To: <CAJfpegsAvjfixdO9iRDsV2XwvGaQS9GpbBdkKnkxJS=3ghcZ-g@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 18 Oct 2018 14:50:20 +0300
Message-ID: <CAOQ4uxjqmQJmE5xLfqJGCnZoMf6NPtcNso7Fotjy_hGAUObK+w@mail.gmail.com>
Subject: Re: WARNING: possible recursive locking detected in mnt_want_write/mnt_want_write_file_path
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Sasha Levin <alexander.levin@microsoft.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, stefan@agner.ch, Greg KH <gregkh@linuxfoundation.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 17, 2018 at 9:37 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Wed, Oct 17, 2018 at 5:24 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> > Miklos,
> >
> > You must have confused "the algorithm" by including a "fix" commit in
> > rc1 pull request
> > without mentioning that it "Fixes" a commit in the same pull request.
>
> I didn't know there were heuristics other than "Cc: stable@.."
>

Yes. Given a Fixes: label, I bet Cc: stable is not needed to auto select
for stable??

Sasha,

Please note that lack of Fixes: or Cc: stable from some subsystems
is a rather strong indication for NOT for stable.

I suppose that in case of stable branch regression due to incorrect
patch selection there is a strong negative feedback to the algorithm?

Thanks,
Amir.
