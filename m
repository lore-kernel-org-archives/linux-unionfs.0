Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb1-f181.google.com ([209.85.219.181]:38959 "EHLO
        mail-yb1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbeIMAyb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Sep 2018 20:54:31 -0400
Received: by mail-yb1-f181.google.com with SMTP id c4-v6so2272923ybl.6
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Sep 2018 12:48:26 -0700 (PDT)
MIME-Version: 1.0
References: <5B995210.1030104@pobox.com>
In-Reply-To: <5B995210.1030104@pobox.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 12 Sep 2018 22:48:15 +0300
Message-ID: <CAOQ4uxgcDaVM+Nm3EpMKf07u20hA+5nY3rCceNrdk8QuQvz1+g@mail.gmail.com>
Subject: Re: How to access "upper" directory of overlayfs programatically
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: jdb2@pobox.com
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

[changing over to overlayfs list]

On Wed, Sep 12, 2018 at 8:52 PM Jonathan Busby <jdb2@pobox.com> wrote:
>
> Hello. I'm new to this list and I don't know if this is the right forum
> for my question, but, I've asked this same question on many forums and
> never received an answer -- please don't flame me.
>
> I have a Debian based Linux live system which is running out of RAM and
> was booted without the "persistent" boot option, so the capser-rw
> filesystem was never created.
>
> I wish to gain access to the "upper" directory of the overlayfs
> filesystem in the casper init scripts initramfs "/cow/upper" filesystem
> so that I may programatically save the filesystem, hopefully without
> having to re-implement cp.
>
> I know how to commit the changes of a Debian based live CD session to a
> storage device, but only if the live session in question was booted with
> the "persistent" option.
>
> I've looked at the overlayfs source code but I still can't figure out
> how to accomplish what I want.
>
> I'm sorry if this is  stupid question -- hopefully it's not.
>

I don't think the programmable API you think of exists, but maybe
you can get access to upper dir as admin user.

Please share the init scripts responsible for the mounts at live CD boot
and the content of /proc/self/mountinfo

Thanks,
Amir.
