From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Optional switching off cow in overlayfs
Date: Mon, 22 Jun 2015 15:53:54 +0200
Message-ID: <CAJfpegsVqzVhq8BjCwqA+6dEZey0aNb4amnnOT_JVDfzki9v1g@mail.gmail.com>
References: <5582C6C1.8080602@samsung.com>
	<13405.1434634748@warthog.procyon.org.uk>
	<5582D8F7.1060700@samsung.com>
	<CAJfpegsP-_MAKybYZ=uS3UCxsxL9Hv-cJ-GYrVL4h3B+tWZF9A@mail.gmail.com>
	<5588116E.20509@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:35712 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbbFVNxz (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 22 Jun 2015 09:53:55 -0400
Received: by qcmc1 with SMTP id c1so16780604qcm.2
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jun 2015 06:53:54 -0700 (PDT)
In-Reply-To: <5588116E.20509@samsung.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jan Olszak <j.olszak@samsung.com>
Cc: David Howells <dhowells@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Jun 22, 2015 at 3:45 PM, Jan Olszak <j.olszak@samsung.com> wrote:

> The lower fs is most likely ext4.
> Unfortunately making a file immutable won't solve the problem. There's
> nothing wrong in modifying the file and it should stay possible.
>
> I just want to switch off copy on write for some files. Can you see another
> way?

Ah, you want to allow modification of file on the lower layer?

You can bind mount individual files from the lower layer to the
overlay.  That fixes the "allow modification" part.  But what should
happen on rename or unlink?

Thanks,
Miklos
