From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: Fix dereferencing possible ERR_PTR()
Date: Tue, 17 Sep 2019 10:06:23 +0200
Message-ID: <CAJfpeguMAzej0OroDXLJsntx5R_XQWOcgSCZLFe=M8e4=A8CAA@mail.gmail.com>
References: <1568017796-27513-1-git-send-email-dingxiang@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1568017796-27513-1-git-send-email-dingxiang@cmss.chinamobile.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ding Xiang <dingxiang@cmss.chinamobile.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Sep 9, 2019 at 10:30 AM Ding Xiang
<dingxiang@cmss.chinamobile.com> wrote:
>
> if ovl_encode_real_fh() fails, no memory was allocated
> and the error in the error-valued pointer should be returned.

Applied, thanks.

Miklos
