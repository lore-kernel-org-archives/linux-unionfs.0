From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/6] ovl: check if upperdir fs supports O_TMPFILE
Date: Mon, 16 Jan 2017 16:16:17 +0200
Message-ID: <CAOQ4uxjYkohzqSnpAg45WMEGxFEFYJbi3FCrdaODz3SjBBTPZQ@mail.gmail.com>
References: <1484488652-611-1-git-send-email-amir73il@gmail.com>
 <1484488652-611-3-git-send-email-amir73il@gmail.com> <CAJfpeguX-N0RXrO3oj_ebWPuMPeRcvHn68dx8pO72KdQxthTUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36090 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751005AbdAPOQX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Jan 2017 09:16:23 -0500
In-Reply-To: <CAJfpeguX-N0RXrO3oj_ebWPuMPeRcvHn68dx8pO72KdQxthTUQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Jan 16, 2017 at 4:02 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Sun, Jan 15, 2017 at 2:57 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> This is needed for choosing between concurrent copyup
>> using O_TMPFILE and legacy copyup using workdir+rename.
>
> I'm really wondering if we should constrain upper fs to those that:
>
>  - can do RENAME_EXCHANGE and RENAME_WHITEOUT
>  - can do ->tmpfile() which is currently a superset of the above
>  - can do xattr, again a superset

Makes sense to me.
Let me know if you want me to add the rename flag test.

>
> The question is whether anybody actually using it with an fs that
> doesn't have all of the above.  Because if so, we need to keep
> supporting them.  Perhaps we should add warnings about deprecation and
> if nobody complains we can remove support for non-conformant fs.
>


But how exactly do we "support" those fs right now?
Any attempt to use them would result in -EINVAL, because we will
bw requesting RENAME_EXCHANGE and RENAME_WHITEOUT
