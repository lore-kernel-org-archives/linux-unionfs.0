From: Sergey Korshunoff <seyko2@gmail.com>
Subject: Re: aufs as root vor openvz CT
Date: Fri, 22 Aug 2014 16:04:37 +0400
Message-ID: <CAKG6wnYTE8YK-2OXGcBph3q4mY9zqJqRu4K-LULE0F0=RO1fAg@mail.gmail.com>
References: <CAKG6wnaq1BwLgMNy27i8ggzt_qMnUb0KVNQg=Z85nz1LbXttUg@mail.gmail.com>
	<29716.1405886425@jrobl>
	<CAKG6wnYsDk8_JoG8QrHZ3ZtDicnwt__6AGTod-Ozqi5gjoZTdw@mail.gmail.com>
	<1728348.LhyPPIypjG@xrated>
	<9782.1406084358@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:47816 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaHVMEi (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 22 Aug 2014 08:04:38 -0400
Received: by mail-ie0-f176.google.com with SMTP id tr6so6349043ieb.21
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Aug 2014 05:04:37 -0700 (PDT)
In-Reply-To: <9782.1406084358@jrobl>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: sfjro@users.sourceforge.net
Cc: Hans-Peter Jansen <hpj@urpla.net>, linux-unionfs@vger.kernel.org

Hello!

2014-07-23 6:59 GMT+04:00, sfjro@users.sourceforge.net
<sfjro@users.sourceforge.net>:
> I'd ask generic questions (to anyone).
> - Is such handling done in the container, or in the generic linux
>   checkpoint/restart?
> - If it is done in the generic feature, then is the linux
>   checkpoint/restart feature specific to the containers?
> - If not, we will be able to reproduce without any containers, no
>   openvz, no old kernel.
>
> As a first step, I need to know the detail steps to reproduce the
> problem since I don't know much about suspend/resume.

A generic hibernate with aufs  as a root fs is OK, ie there is no problem
executing a  hibernate command and then restarting OS from a saved state.

A problem is with a containers suspend/resume. Currently a openvz.org team
is working on RHEL7 based kernel (version 3.10). I don;t know if
suspend/resume for contaimers can be done with mainstream kernel. I
will to test a RHEL7 based kernel
when a openvz.team released it.

Then I will try to make a livecd like http://download.openvz.org/livecd/ but
based on gentoo and with kernels 2.6.32 and 3.10.x which can be used
to demontrate a problem.
