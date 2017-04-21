From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: Overlayfs reverse mapping
Date: Sat, 22 Apr 2017 04:34:47 +0900
Message-ID: <7402.1492803287@jrobl>
References: <CAOQ4uxid0C3PLnfopBWAtWkNqyuMkickoUrZzDmj6-bEOWCDcA@mail.gmail.com> <CAJfpegtWH0P87mYMRB+sLpa0RSOVjvo4Ph1DH8E41UJiyJjiKw@mail.gmail.com> <CAOQ4uxhTaY4N5_02kg+5fK0nYLFyEKVVFfWtO5AeC33Qc7CNDw@mail.gmail.com> <CAJfpegv7kR-zDaE2wfD5e=_yUVnxDLMe28okMm3tTrURjLT1XQ@mail.gmail.com> <5399.1492800261@jrobl> <CAOQ4uxiBKku_jh8bbCvB1L9TytdcqDUuJSnjCREsc+nacYngtw@mail.gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail05-md.ns.itscom.net ([175.177.155.115]:58256 "EHLO
        mail05-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425105AbdDUTez (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 21 Apr 2017 15:34:55 -0400
In-Reply-To: <CAOQ4uxiBKku_jh8bbCvB1L9TytdcqDUuJSnjCREsc+nacYngtw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

Amir Goldstein:
> That would be names of files reserved for use by fs that user
> cannot use (i.e. .wh. files). Miklos did not  mean that aufs handles
> lost+found, but that it lives without a problem with reserved filenames.

Ah, reserving a filename prefix ".wh.". I see.
Thanx for the explanation.

By the way, putting extra things under lost+found is not a good idea I
think.
Have you ever tried restoring files manually from lost+found?
When an administrator meets such case, he will digging lost+found and
copy the files one by one with guessing the filenames. If he is not sure
what the file is, then he may leave it under lost+found.
For such case, the entries related to overlayfs will be left, and the
administrator will spend some sleepless nights with thinking "What are
these files? How can I restore them?"


J. R. Okajima
