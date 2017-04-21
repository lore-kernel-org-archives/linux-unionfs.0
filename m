From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: Overlayfs reverse mapping
Date: Sat, 22 Apr 2017 03:44:21 +0900
Message-ID: <5399.1492800261@jrobl>
References: <CAOQ4uxid0C3PLnfopBWAtWkNqyuMkickoUrZzDmj6-bEOWCDcA@mail.gmail.com> <CAJfpegtWH0P87mYMRB+sLpa0RSOVjvo4Ph1DH8E41UJiyJjiKw@mail.gmail.com> <CAOQ4uxhTaY4N5_02kg+5fK0nYLFyEKVVFfWtO5AeC33Qc7CNDw@mail.gmail.com> <CAJfpegv7kR-zDaE2wfD5e=_yUVnxDLMe28okMm3tTrURjLT1XQ@mail.gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail04-md.ns.itscom.net ([175.177.155.114]:43454 "EHLO
        mail04-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1041325AbdDUSoX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 21 Apr 2017 14:44:23 -0400
In-Reply-To: <CAJfpegv7kR-zDaE2wfD5e=_yUVnxDLMe28okMm3tTrURjLT1XQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

Miklos Szeredi:
> OTOH lost+found is just a plain old directory that is handled by
> userspace tools only.  No kernel fs driver treats /lost+found
> specially.  So putting this in upperdir would be a namespace pollution
> issue and generally we'd like to avoid that.  Aufs has lived with that
> sort of thing, and probably it wouldn't be a problem in practice.  But

??
As far as I know, aufs doesn't handle lost+found specially, but the
layer fs handles. What is the "namespace pollution" you call?


J. R. Okajima
