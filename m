From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2] ovl: fix possible use after free on redirect dir lookup
Date: Wed, 18 Jan 2017 15:55:42 +0100
Message-ID: <CAJfpegvmARfd-S6Zbqcru9z4EWf=BU2uBwdJhM-MRRD+_DEOdw@mail.gmail.com>
References: <1484656498-5265-1-git-send-email-amir73il@gmail.com>
 <1484727330-7260-1-git-send-email-amir73il@gmail.com> <20170118103834.GG27207@veci.piliscsaba.szeredi.hu>
 <CAOQ4uxjihZFvNiJBf2DVKgJ6mVJwsNK0LPGtC-mtfd8g3AdnLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f178.google.com ([74.125.82.178]:35577 "EHLO
        mail-ot0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753176AbdARPER (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Jan 2017 10:04:17 -0500
Received: by mail-ot0-f178.google.com with SMTP id 65so10566803otq.2
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Jan 2017 07:04:17 -0800 (PST)
In-Reply-To: <CAOQ4uxjihZFvNiJBf2DVKgJ6mVJwsNK0LPGtC-mtfd8g3AdnLA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Jan 18, 2017 at 12:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Jan 18, 2017 at 12:38 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:

>> Only compile tested.  Please let me know if this works or not.
>>
>
> It works.

Asserts added and pushed.

Thanks,
Miklos
