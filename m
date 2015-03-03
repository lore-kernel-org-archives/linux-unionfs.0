From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: stat inconsistency with overlayfs
Date: Tue, 3 Mar 2015 16:14:44 +0100
Message-ID: <CAJfpegtV-UZmnu8HvH9RQiewv14bqpUao=OvnOCCJGhE0DXDHw@mail.gmail.com>
References: <54E779BB.8030209@web2web.at>
	<54EEAE3A.5000006@huawei.com>
	<37851744.28042779.1424933137550.JavaMail.zimbra@redhat.com>
	<54F4CC02.3040808@web2web.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:37548 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbbCCPOp (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 3 Mar 2015 10:14:45 -0500
Received: by qcrw7 with SMTP id w7so30696811qcr.4
        for <linux-unionfs@vger.kernel.org>; Tue, 03 Mar 2015 07:14:44 -0800 (PST)
In-Reply-To: <54F4CC02.3040808@web2web.at>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Atom2 <ariel.atom2@web2web.at>
Cc: Xu Wang <xuw@redhat.com>, hujianyang <hujianyang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

Atom2,

> The use case behind that is to be able to backup only files from the
> upperdir for several systems sharing a common lowerdir filesystem. I have
> used that (scripted approach via rsync) now for quiet some time and a few
> kernels back and it seemed to have worked very well.

Why don't you just back up the upper directory itself instead of
messing around with device numbers?

Thanks,
Miklos
