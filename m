Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730670AbeK0XDJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 27 Nov 2018 18:03:09 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wARBxIXV135683
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Nov 2018 07:05:28 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2p149bbxdb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Nov 2018 07:05:27 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <zohar@linux.ibm.com>;
        Tue, 27 Nov 2018 12:05:25 -0000
Subject: Re: [PATCH] IMA: Mask O_RDWR if FMODE_READ is set
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Tue, 27 Nov 2018 07:05:09 -0500
In-Reply-To: <20181126163847.xy3acvltyeb75nb4@merlin>
References: <20181126163847.xy3acvltyeb75nb4@merlin>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1543320309.3902.137.camel@linux.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, syzbot+ae82084b07d0297e566b@syzkaller.appspotmail.com
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, syzkaller-bugs@googlegroups.com, linux-integrity@vger.kernel.org, linux-unionfs@vger.kernel.org, amir73il@gmail.com
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, 2018-11-26 at 10:38 -0600, Goldwyn Rodrigues wrote:
> A file can be opened with open(O_WRONLY | O_RDWR), so a FMORE_READ
> will not be set, and overlayfs will consider another copy_up() on the same
> file leading to a deadlock on mnt_want_write(). Fix it by masking
> O_RDWR while opening the file in read-only mode.

Shouldn't the open itself fail if both O_WRONLY and O_RDWR are
specified?

Mimi

> 
> 
> Reported-by: syzbot+ae82084b07d0297e566b@syzkaller.appspotmail.com
> Fixes: a408e4a86b36 ("ima: open a new file instance if no read permissions")
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index d9e7728027c6..2efa04e47ff0 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -422,7 +422,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>  	/* Open a new file instance in O_RDONLY if we cannot read */
>  	if (!(file->f_mode & FMODE_READ)) {
>  		int flags = file->f_flags & ~(O_WRONLY | O_APPEND |
> -				O_TRUNC | O_CREAT | O_NOCTTY | O_EXCL);
> +				O_RDWR | O_TRUNC | O_CREAT | O_NOCTTY | O_EXCL);
>  		flags |= O_RDONLY;
>  		f = dentry_open(&file->f_path, flags, file->f_cred);
>  		if (IS_ERR(f)) {
> 
