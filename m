From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH] ovl: no direct iteration for dir with copy up origin
Date: Mon, 26 Jun 2017 09:22:57 +0800
Message-ID: <cde690a2-9288-9f5a-62a6-17f8e6b96fbb@huawei.com>
References: <1498400069-12840-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:8380 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750967AbdFZBXI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Jun 2017 21:23:08 -0400
In-Reply-To: <1498400069-12840-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On 2017/6/25 22:14, Amir Goldstein Wrote:
> If a non-merge dir in an overlay mount has an overlay.origin xattr, it
> means it was once an upper merge dir, which may contain whiteouts and
> then the lower dir was removed under it.
> 
> Do not iterate real dir directly in this case to avoid exposing whiteouts.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/readdir.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
> 
> Yi,
> 
> You missed a very big spot and so did I in review.
> Your patch doen't hide whiteouts from readdir and it doesn't
> even pass you own xfstest...
> 
> Anyway, here are the missing parts picked from my impure readdir
> patch.
> 

Hi Amir,

Yes, I missed whiteouts check in readdir because I saw your readdir
patch has already fix it, so my xfstest test this case. Do you
think we should merge this two patch ?

Thanks,
ZhangYi.
