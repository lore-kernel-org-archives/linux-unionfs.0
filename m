From: Sergey Korshunoff <seyko2@gmail.com>
Subject: Re: aufs as root vor openvz CT
Date: Tue, 9 Dec 2014 19:43:06 +0300
Message-ID: <CAKG6wnZ2BooW_1V5MkJ98yELsTkRh3OnkWMyEcuRwwruG6XDGw@mail.gmail.com>
References: <CAKG6wnaq1BwLgMNy27i8ggzt_qMnUb0KVNQg=Z85nz1LbXttUg@mail.gmail.com>
	<29716.1405886425@jrobl>
	<CAKG6wnYsDk8_JoG8QrHZ3ZtDicnwt__6AGTod-Ozqi5gjoZTdw@mail.gmail.com>
	<1728348.LhyPPIypjG@xrated>
	<9782.1406084358@jrobl>
	<CAKG6wnYTE8YK-2OXGcBph3q4mY9zqJqRu4K-LULE0F0=RO1fAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:44332 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbaLIQnH (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 9 Dec 2014 11:43:07 -0500
Received: by mail-ig0-f171.google.com with SMTP id z20so4841076igj.16
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Dec 2014 08:43:06 -0800 (PST)
In-Reply-To: <CAKG6wnYTE8YK-2OXGcBph3q4mY9zqJqRu4K-LULE0F0=RO1fAg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: sfjro@users.sourceforge.net
Cc: Hans-Peter Jansen <hpj@urpla.net>, linux-unionfs@vger.kernel.org

Succes story.
I modified a checkpoint part of the openvz 2.6.32 kernel (cpt_mm.c)
which handles a vma areas
by replacing vma->vm_file with vma->vm_prfile if vma->prfile != 0.
After that a checkpoint-restore is performed without any error.

I think that CRIU utils must know about that field in the vma struct
(if there is that filed) before CRIU can suspend a container located
inside an aufs file system.

Another solution may be to use vma_ops in aufs and to keep
vma->vm_file unchanged,
