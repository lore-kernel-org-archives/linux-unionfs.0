From: Raphael Hertzog <raphael@ouaza.com>
Subject: Re: [PATCH] ovl: fix failure to fsync lower dir
Date: Fri, 10 Nov 2017 10:10:18 +0100
Message-ID: <20171110091018.tonnsn2yut4byk2q@home.ouaza.com>
References: <1510126786-16044-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.vm.ouaza.com ([212.83.178.2]:55383 "EHLO mail.vm.ouaza.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751265AbdKJJKU (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 04:10:20 -0500
Content-Disposition: inline
In-Reply-To: <1510126786-16044-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org

Hi Amir,

Le mercredi 08 novembre 2017, Amir Goldstein a écrit :
> The problem reported by Raphael is that new PostgreSQL 10.0 with a
> database in overlayfs where lower layer in squashfs fails to start.
> The failure is due to fsync error, when PostgreSQL does fsync on all
> existing db directories on startup and a specific directory exists
> lower layer with no changes.

I confirm that this patch is enough to fix my issue.

Tested-by: Raphaël Hertzog <hertzog@debian.org>

I wonder if we can have a similar problem with a file. Is it possible to
fsync a file opened in read-only mode? Even if it's possible, I assume
this is really rare.

And when you open a file with read-write permissions, when does the
copy-up happen? If it's immediately, then fsync on such a file is safe as
well.

Cheers,
-- 
Raphaël Hertzog ◈ Writer/Consultant ◈ Debian Developer

Discover the Debian Administrator's Handbook:
→ https://debian-handbook.info/get/
