From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Support for filesystems with d_revalidate (NFS)
Date: Tue, 10 Feb 2015 21:28:10 +0100
Message-ID: <CAJfpegssRaFSZXJbKcJGqef-_X3P24LSJF+ODP2sE_QZQa5=hQ@mail.gmail.com>
References: <E4C1F457-0D8A-4118-9F10-819D8CCA5ADE@ornl.gov>
	<20150209211225.GJ32617@cray.com>
	<C111BFAB-F3C3-49AA-A34E-3E110EC86229@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:49505 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbbBJU2L (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 10 Feb 2015 15:28:11 -0500
Received: by mail-qc0-f177.google.com with SMTP id s11so5145225qcv.8
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Feb 2015 12:28:11 -0800 (PST)
In-Reply-To: <C111BFAB-F3C3-49AA-A34E-3E110EC86229@ornl.gov>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "Caldwell, Blake A." <blakec@ornl.gov>
Cc: Eric Jones <ejones@cray.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Feb 10, 2015 at 7:26 PM, Caldwell, Blake A. <blakec@ornl.gov> wrote:
> Thanks. That could help in the short-term. I'd hope to see see this in mainline eventually. If someone could elaborate on the blanket exclusion of d_revalidate, I'd like to see if the task to add read-only NFS support is reasonable.

It was easier to merge upstream that way (the acutal change was
suggested by Al Viro).  We could add it back if we can show that it
doesn't hurt.

Generally distributed fs need ->d_revalidate because filesystem can
change without any write activity on the local mount (and even if
mounted read-only) to check for remote changes.

Overlayfs assumes that lower fs is constant and behavior is undefined
if the underlying filesystem changes.  So basically we don't care
about d_revalidate, but may still want to call it due to possible
assumptions about it being called by the VFS.

So easy option is to call ->d_revalidate and error out if it returns "invalid"

Thanks,
Miklos
