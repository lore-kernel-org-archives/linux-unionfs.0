From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Overlayfs snapshots pre announce
Date: Fri, 2 Dec 2016 15:05:37 +0100
Message-ID: <CAJfpegsLuy5DjeGEeEs3=RgBkWuku9PSesN1Dk=5pKtS_zHdkg@mail.gmail.com>
References: <CAOQ4uxjXpd_Fy3vBfzcXZYudPoZyXkrLEofLNQ0YPB6HeD9ZgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:33601 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758012AbcLBOFn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Dec 2016 09:05:43 -0500
Received: by mail-oi0-f52.google.com with SMTP id w63so267061638oiw.0
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Dec 2016 06:05:43 -0800 (PST)
In-Reply-To: <CAOQ4uxjXpd_Fy3vBfzcXZYudPoZyXkrLEofLNQ0YPB6HeD9ZgA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Dec 2, 2016 at 10:30 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Hi Miklos,
>
> Wanted to give you a heads up on upcoming announcement for
> overlayfs snapshots POC, just to give you a sense of what's been
> driving my recent overlayfs development efforts
> and also because I am eager to share the news ;-).

Okay, so this is sort of reverse-overlay.  For this to be useful,
however, there would have to be a way to make the snapshot *after*
/mnt is mounted, no?

Thanks,
MIklos
