From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Bug in overlay FS
Date: Thu, 21 May 2015 17:38:13 +0200
Message-ID: <CAJfpegsGtzK-ykK7tXJjZabAZERJ_NcMyZbeTkB5HB3s-43Skg@mail.gmail.com>
References: <CAJfpegt+O78vh_FcLSVxqY6gnzR7t0GW-D0=RuvyvqikR=RTXQ@mail.gmail.com>
	<1084458602.2805420.1432071057532.JavaMail.yahoo@mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:35499 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbbEUPiO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 21 May 2015 11:38:14 -0400
Received: by qgew3 with SMTP id w3so42308674qge.2
        for <linux-unionfs@vger.kernel.org>; Thu, 21 May 2015 08:38:13 -0700 (PDT)
In-Reply-To: <1084458602.2805420.1432071057532.JavaMail.yahoo@mail.yahoo.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: steve landiss <steve.landiss@yahoo.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>

[Al Viro and linux-unionfs added to Cc]

On Tue, May 19, 2015 at 11:30 PM, steve landiss <steve.landiss@yahoo.co=
m> wrote:
>
> On Tuesday, May 19, 2015 2:12 AM, Miklos Szeredi <miklos@szeredi.hu> =
wrote:
> >
> >
> > On Mon, May 18, 2015 at 10:35 PM, steve landiss <steve.landiss@yaho=
o.com>
> > wrote:
> >
> >> A data consistency bug is demonstrated by the following program:
> >>
> >> - Pick a file from the lower layer that has never been written
> >> - Open it twice once in O_RDONLY (fd1) and once in O_RDWR (fd2)
> >> - Write to fd2, read from fd1 -> data inconsistency!
> >> I understand why it happens, is there a fix planned for this?
> >
> >
>>  Not presently.
> >
> > This is a feature of both overlayfs and union-mounts.  Aufs, a full
> > union-filesystem doesn't suffer from this probelm.
> >
> > Is this causing a real-world problem, or is this purely theoretical=
?

> yum fails right off the bat.  Because it opens a file in read only, t=
hen
> another process or thread writes to the file.
>
> Our build process in Docker does not work because of this, and I know=
 of
> many others that have this issue
>
> overlayfs fails to run container with a strange file checksum error =C2=
=B7 Issue
> #10180 =C2=B7 docker/docker

Okay, this is not easy to fix, but I wouldn't say impossible.

I think it connects with the idea of revoking file descriptors.
Except here we don't want to revoke, but replace on copy-up.

But it might be easier to just to do the union-filesystem thing.

Thanks,
Miklos
