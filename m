From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Overlayfs with NFS lower layer
Date: Thu, 1 Feb 2018 21:24:52 +0200
Message-ID: <CAOQ4uxhHt6cjbX-vGuNDnx7QnHyM3pwn=A6g4UHcE5xXiODF7g@mail.gmail.com>
References: <20180201095951.006e3ca5@raspberrypi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:45927 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753129AbeBATYx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Feb 2018 14:24:53 -0500
Received: by mail-yw0-f170.google.com with SMTP id b16so8498191ywh.12
        for <linux-unionfs@vger.kernel.org>; Thu, 01 Feb 2018 11:24:53 -0800 (PST)
In-Reply-To: <20180201095951.006e3ca5@raspberrypi>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Duncan Hare <dh@synoia.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Feb 1, 2018 at 7:59 PM, Duncan Hare <dh@synoia.com> wrote:
> We are looking at disk less operation:
>
> Some questions
> 1. Is it possible to use an NFS export as the lower layer on Overlayfs?

Yes.

> 2. If 1 is not possible in the current release, what's needed to do
> this?
> 3. Are whiteouts configurable? That is if a file is deleted in the
> upper layer, can Ocerlay fs revert to thefile of the same name in
> the lower layer?

I don't understand the use case.
Please give an example.
Do you want to revert while overlay is mounted? offline?
I guess you can just delete the whiteout when overlay is offline.

Amir.
