Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F311D555
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Dec 2024 00:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734481401; cv=none; b=G9mw0YF4Ddlqo8htjxjf13I7+gSV5CxdnEnQ0aAM/VUgr+T/SlZu1/C/GbcQa2XAD1DvNja/tRwVe/3EvtGxJf2UXNU89vQBn3qAVIIW22Dg2pq4AdIfUGZRCKfWbmmjSq5mO3dT+FLYUc/lfj4Hx3oxVK+3rNYhBjZ6yEbTx1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734481401; c=relaxed/simple;
	bh=kXWXxQioWe/FGa765bq7JpbDDUzWFD3fvQSF30Hh8aM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=KDT3B4qGzgP2WTbLag2YfdwM6l2GlCq7A4X9WyixL+2qPz+9DaiYEBUairzqRgaLVlk6W63rUXqKig2ZgWDDXNTKru8MS3E3dwp57dHpGqE3EspVVgkU18TTo/tRRzmwttTeKzBT0CWqqgEpAWNZXqD+GJ5wPB82mu6KyFhICqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com; spf=pass smtp.mailfrom=arista.com; dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b=a+1MVI5J; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arista.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b="a+1MVI5J"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7fd17f231a7so3515531a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Dec 2024 16:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1734481399; x=1735086199; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wi6cncT81BF+nPRpZBXi0DKtPXxPUvWy6T/qWA+xSWY=;
        b=a+1MVI5JzMXNOHldr69/3yBZad5fNeSHWbjWWklrRtPABqXbdBfrnVjeFESCtRDMOs
         K+CMzvdjJWv5tNRfYFHYmhs6AsjM3swjVK76qnY/HBhMqH1VQ14Zdng/h/SYXt2PD9dS
         xdLgaaEcved8oeyf/W5+bKNpZuyIXWjNLQOc+21rB3Tp6a1dW+rEMzPujTfJP6MthcWC
         4/QqKFNR966XIcVo5RJiOXViid8Pmbx7WXq0E5YllYIuYBqRbQCUq+m4x8LMgPDRk3wA
         3mj4GZewURR9JlfMvifpj9tq9Mq583XrOvYzURSl7gAHxOstHRB7dns/FG3TPWA3ibBY
         jtsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734481399; x=1735086199;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wi6cncT81BF+nPRpZBXi0DKtPXxPUvWy6T/qWA+xSWY=;
        b=Jln1mhJ3AKBX3SVGBoM3Bjl0bwJRjyP0uFSEC7naXjVtrwWMer95VuG7rqLfgRRy/T
         2QWLjM+NrGRF+P//rXZQNK2Iguqg2Keo3BCDYx3N6Hv5+RCRu1fQ/WE/tr6Css+YGt/7
         zpF5baWfOjd8AsKMwbIWA8ONJNmaL24cOSYkoGKL62RITFBKc8Qp8o7SVmIqKtd2oLLy
         A3l/FqiOh+8Z1LZTLKhQcXNnscFqArhDIrSVAXgcWIH9HYKM9pjZ43rd2OZMC1SrFCDA
         iF0Nxii24u3/NdjNxVmnYVvtgkVhGFLGHPXBm2PRXMMtwqehMsgw8o+vX9yeyDJqjpWl
         WPzw==
X-Gm-Message-State: AOJu0YxiJEBJ2+10+5SaZQdXbGdQ0GuxdDk5610wlmaRyIt3NUDGUBv7
	Rqnr02o9sEEyFGfLZLl3n5PKQuO+b4oKgRY4QaKfmct3wOFCylDdrJ1xCyQLqW9UNEydklAScSD
	Y9gtROfYoWzLmIeFNQFv+ttJINYrVumx+HNP1
X-Gm-Gg: ASbGnctIDkNgzZzQJpQ0BvpbG4dazJVhtnTTvXat6oamZ4ZYG4PQR5BCpimCMvdjcg6
	OAk2f7hR9ZJiOIdr1m2grrWmwj+PkUk5QiDZVj80=
X-Google-Smtp-Source: AGHT+IEVnlhPoJcdfnhwGm/iVjO0MXZUkv37sFBtpUFdWVqMVpDOU5eYQQfqoDP+c+9ToKsBUxGGn2QFBATT/4LOBjg=
X-Received: by 2002:a17:90b:2812:b0:2ee:c5ea:bd91 with SMTP id
 98e67ed59e1d1-2f2e935e83amr1297853a91.29.1734481399378; Tue, 17 Dec 2024
 16:23:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Dmitry Safonov <dima@arista.com>
Date: Wed, 18 Dec 2024 00:23:08 +0000
Message-ID: <CAGrbwDTLt6drB9eaUagnQVgdPBmhLfqqxAf3F+Juqy_o6oP8uw@mail.gmail.com>
Subject: overlayfs: WARN_ONCE(Can't encode file handler for inotify: 255)
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>, 
	Sahil Gupta <s.gupta@arista.com>
Content-Type: text/plain; charset="UTF-8"

Hi Amir and Miklos, linux-unionfs,

On v6.9.0 kernel we stepped over the WARN_ON() in show_mark_fhandle():

> ------------[ cut here ]------------
> Can't encode file handler for inotify: 255
> WARNING: CPU: 0 PID: 11136 at fs/notify/fdinfo.c:55 show_mark_fhandle+0xfa/0x110
> CPU: 0 PID: 11136 Comm: lsof Kdump: loaded Tainted: P        W  O       6.9.0 #1
> RIP: 0010:show_mark_fhandle+0xfa/0x110
> Code: 00 00 00 5b 41 5c 5d e9 44 21 97 00 80 3d 0d af 99 01 00 75 d8 89 ce 48 c7 c7 68 ad 4a 82 c6 05 fb ae 99 01 01 e8 f6 98 cc ff <0f> 0b eb bf e8 4d        29 96 00 66 66 2e 0f 1f 84 00 00 00 00 00 66 90
...
> Call Trace:
>  <TASK>
>  inotify_show_fdinfo+0x124/0x170
>  seq_show+0x188/0x1f0
>  seq_read_iter+0x115/0x4a0
>  seq_read+0xf9/0x130
>  vfs_read+0xb6/0x330
>  ksys_read+0x6b/0xf0
>  __do_fast_syscall_32+0x80/0x110
>  do_fast_syscall_32+0x37/0x80
>  entry_SYSCALL_compat_after_hwframe+0x75/0x75
> RIP: 0023:0xf7f93569

it later reproduced on v6.12.0. With some debug, it was narrowed down
to the way overlayfs encodes file handlers in ovl_encode_fh(). It
seems that currently it calculates them with the help of dentries.
Straight away from that, the reproducer becomes an easy drop_caches +
lsof (which parses procfs and finds some pid(s) that utilize inotify,
reading their correspondent fdinfo(s)).

So, my questions are: is a dentry actually needed for
ovl_dentry_to_fid()? Can't it just encode fh based on an inode? It
seems that the only reason it "needs" a dentry is to find the origin
layer in ovl_check_encode_origin(), is it so?

I guess, the potential solution here would be either to populate the
dentry back (likely racy and ugh) or just encode file handles based on
the lower-inode? IIUC, old file handles will become stale anyway after
dropping the caches?

As a rare visitor to fs code, not sure I described the problem or
understood it well enough.
FWIW, reverting commit 16aac5ad1fa9 ("ovl: support encoding
non-decodable file handles") seems to "fix" the warning locally (not
considering it a long-term fix).

Thanks,
            Dmitry
