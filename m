From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][PATCH] ovl: check lower ancestry on encode of lower dir
 file handle
Date: Fri, 16 Feb 2018 16:15:58 +0100
Message-ID: <CAJfpegvXLkx4Jjjd8v+A8kMom9yA7OUOc0N7UdvNCnvpf9R-uw@mail.gmail.com>
References: <1517919700-29182-1-git-send-email-amir73il@gmail.com>
 <1517919700-29182-2-git-send-email-amir73il@gmail.com> <CAJfpegvqnhNiX3Cqux=Pa59TJ40ki5CEBDtjAnRravaTLgDzqg@mail.gmail.com>
 <CAOQ4uxgAtSi-OAkAfvBf+RQ0omNM1UtTbuQWPooM8ZJS++y9bw@mail.gmail.com>
 <CAJfpegv1CtAmBk-ZAXfymtkXLBnaWrq3yrD=NUUyxAZ1pGeVag@mail.gmail.com> <CAOQ4uxjGPEd+pCvKfm22bg=EuSix2uikPwCGnH5C_KRDNFcBzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:36890 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967097AbeBPPP7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Feb 2018 10:15:59 -0500
Received: by mail-qt0-f172.google.com with SMTP id d26so4151225qtj.4
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Feb 2018 07:15:59 -0800 (PST)
In-Reply-To: <CAOQ4uxjGPEd+pCvKfm22bg=EuSix2uikPwCGnH5C_KRDNFcBzg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Feb 16, 2018 at 12:56 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> I assume you will be making the modifications you suggested on commit.

Sure.  Pushed the three fixes to overlayfs-next.

Thanks,
Miklos
