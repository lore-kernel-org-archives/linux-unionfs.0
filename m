Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb1-f173.google.com ([209.85.219.173]:34673 "EHLO
        mail-yb1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728074AbfDRL0S (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Apr 2019 07:26:18 -0400
MIME-Version: 1.0
References: <S2388535AbfDRKs3/20190418104829Z+779@vger.kernel.org> <830baec0-aa9e-113d-b5c1-c6cad4ca65f1@gmail.com>
In-Reply-To: <830baec0-aa9e-113d-b5c1-c6cad4ca65f1@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 18 Apr 2019 14:26:06 +0300
Message-ID: <CAOQ4uxgBVsKpVbpa9g1NGpREwQZK-NsVdmArADtafS3YRiGkbQ@mail.gmail.com>
Subject: Re: OverlaysFS
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: StuartIanNaylor <rolyantrauts@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 18, 2019 at 1:58 PM StuartIanNaylor <rolyantrauts@gmail.com> wrote:
>
> Apols to ask here but are there any tools for overlayFS?

FYI, the overlayfs list is over at <linux-unionfs@vger.kernel.org>

>
> https://github.com/kmxz/overlayfs-tools is just about the only thing I
> can find.

There is also https://github.com/hisilicon/overlayfs-progs which
can check and fix overlay layers, but it hasn't been updated in a while.

Thanks,
Amir.
