From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [bug report] ovl: factor out ovl_free_fs() helper
Date: Mon, 13 Nov 2017 10:17:21 +0100
Message-ID: <CAJfpegs-ZSX1mOhR+qim1OoosE3EhmHVFQ1sOz+GfndKgsS+eg@mail.gmail.com>
References: <20171113090546.jdkiaxu3sidsawxi@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:53752 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752044AbdKMJRX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Nov 2017 04:17:23 -0500
Received: by mail-wr0-f173.google.com with SMTP id u40so13763381wrf.10
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Nov 2017 01:17:22 -0800 (PST)
In-Reply-To: <20171113090546.jdkiaxu3sidsawxi@mwanda>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Nov 13, 2017 at 10:05 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> Hello Miklos Szeredi,
>
> The patch df6c653fd465: "ovl: factor out ovl_free_fs() helper" from
> Nov 9, 2017, leads to the following static checker warning:
>
>         fs/overlayfs/super.c:1260 ovl_fill_super()
>         error: we previously assumed 'ofs' could be null (see line 1156)

Thanks,  already fixed in latest version.

Miklos
