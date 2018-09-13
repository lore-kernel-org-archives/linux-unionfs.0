Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:46624 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727628AbeINA3M (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Sep 2018 20:29:12 -0400
Received: by mail-yb1-f194.google.com with SMTP id y20-v6so3731763ybi.13
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Sep 2018 12:18:21 -0700 (PDT)
MIME-Version: 1.0
References: <5B9AA5EC.8050600@pobox.com> <5B9AB275.7010408@pobox.com>
In-Reply-To: <5B9AB275.7010408@pobox.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 13 Sep 2018 22:18:08 +0300
Message-ID: <CAOQ4uxhT0R=sisyfDcvH+2SFbYMKsLhv0Ei+RtGnQqVN4kBMGQ@mail.gmail.com>
Subject: Re: Re: How to access "upper" directory of overlayfs programatically
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Jonathan Busby <jdb2@pobox.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Sep 13, 2018 at 10:03 PM Jonathan Busby <jdb2@pobox.com> wrote:
>
>
>
> -------- Forwarded Message --------
> Subject: Re: How to access "upper" directory of overlayfs programatically
> Date: Thu, 13 Sep 2018 13:01:16 -0500
> From: Jonathan Busby <jdb2@pobox.com>
> To: Amir Goldstein <amir73il@gmail.com>
>
>
>
> On 09/13/2018 12:33 PM, Jonathan Busby wrote:
> >
> >
> > On 09/12/2018 02:48 PM, Amir Goldstein wrote:
> >> [changing over to overlayfs list]
> >
> > Thanks for this! :D I had been searching for an overlayfs mailing list
> > but it seems I overlooked unionfs.
> >
> >>
> >> On Wed, Sep 12, 2018 at 8:52 PM Jonathan Busby <jdb2@pobox.com> wrote:
> >>>
> >>> Hello. I'm new to this list and I don't know if this is the right forum
> >>> for my question, but, I've asked this same question on many forums and
> >>> never received an answer -- please don't flame me.
> >>>
> >>> I have a Debian based Linux live system which is running out of RAM and
> >>> was booted without the "persistent" boot option, so the capser-rw
> >>> filesystem was never created.
> >>>
> >>> I wish to gain access to the "upper" directory of the overlayfs
> >>> filesystem in the casper init scripts initramfs "/cow/upper" filesystem
> >>> so that I may programatically save the filesystem, hopefully without
> >>> having to re-implement cp.
> >>>
> >>> I know how to commit the changes of a Debian based live CD session to a
> >>> storage device, but only if the live session in question was booted with
> >>> the "persistent" option.
> >>>
> >>> I've looked at the overlayfs source code but I still can't figure out
> >>> how to accomplish what I want.
> >>>
> >>> I'm sorry if this is  stupid question -- hopefully it's not.
> >>>
> >>
> >> I don't think the programmable API you think of exists, but maybe
> >> you can get access to upper dir as admin user.
> >>
> >> Please share the init scripts responsible for the mounts at live CD boot
> >> and the content of /proc/self/mountinfo
> >
> > The contents of /proc/self/mountinfo are can be found here :
> >
> > https://pastebin.com/raw/9uQdJ66w
> >
> > The init scripts responsible for the live CD mounts can be found here :
> >
> > https://www.dropbox.com/s/j4zqsn8avxrv6zf/initrd-scripts.tar.gz?dl=0
> >
> > Thanks,
> >
> > Jonathan
> >
> >>
> >> Thanks,
> >> Amir.
> >>
>
> I forgot to mention that the init scripts that handle mounting the
> overlayfs chroot are located in the /scripts/casper directory, and the
> main script is just called "casper".
>

Jonathan,

Not sure this is what you were looking for, but one thing you could try is
to iterate the directories of root fs (similar to find / -xdev) executing stat()
on files inside directories.

Depending on your kernel version, the findings might vary, but I would
expect all values of st_dev to be identical (this is what makes find -xdev
stop on fs boundary).

For non directories, the value of st_dev is an indication to the layer (at
least in your specific non-same-fs combination of upper/lower).

If you create a new file, it will be in upper, so you can use its st_dev as
the identifier of the upper layer. All files with the same st_dev are either
newly created files or modified files, so you can copy them to backup.

Directories will not carry a similar indication if they are modified or new.
This method will not give you the list of deleted files (whiteout in upper).

Thanks,
Amir.
