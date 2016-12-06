From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Overlayfs snapshots pre announce
Date: Tue, 6 Dec 2016 11:41:56 +0100
Message-ID: <CAJfpegva_u_PnhM+GtopuRF1-Oj9sq7orK3Ao3MLwtHiASPXqg@mail.gmail.com>
References: <CAOQ4uxjXpd_Fy3vBfzcXZYudPoZyXkrLEofLNQ0YPB6HeD9ZgA@mail.gmail.com>
 <CAJfpegsLuy5DjeGEeEs3=RgBkWuku9PSesN1Dk=5pKtS_zHdkg@mail.gmail.com>
 <CAJfpegtJ7pZNZA3op7iZwCPynYcSCGB6EZ3rZrmdc3zSKucdpA@mail.gmail.com>
 <CAOQ4uxi1-aC8YiBSxSvCzu7-8TJRGjwAn6DBgV3wWF+Vpwf5Ww@mail.gmail.com> <CAOQ4uxh-ZNDcv7sAxX-yaCN=_LLK6qRWpA6w3LScsL6K5S0vWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:33502 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbcLFKl5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Dec 2016 05:41:57 -0500
Received: by mail-oi0-f41.google.com with SMTP id w63so373676906oiw.0
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Dec 2016 02:41:57 -0800 (PST)
In-Reply-To: <CAOQ4uxh-ZNDcv7sAxX-yaCN=_LLK6qRWpA6w3LScsL6K5S0vWA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Dec 5, 2016 at 2:39 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> FYI, I implemented ./run --sn=N test
> for recycling N snapshot as described above.
>
> 3 directory rename tests (rename-move-dir, rename-pop-dir,
> rename-new-pop-dir) fail on snapshot consistency after 1 recycle
> due to a problem I failed to anticipate - redirect by file handle skips
> all middle layers and goes directly to master.

Not sure I understand.   How does redirect/fh skip middle layers?  We
need to merge contents of all layers, so skipping middle layers does
not sound correct.

Thanks,
Miklos
