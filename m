From: Jordi Pujol <jordipujolp@gmail.com>
Subject: Re: v4.13 overlay fs: sometimes fails when creating or moving files
Date: Fri, 8 Sep 2017 21:56:37 +0200
Message-ID: <CACTE=grVbc20+3zQOoJm1Mm7MN9dyP=MeG2f6Vw6gasTCoT58Q@mail.gmail.com>
References: <20170908143704.3c74d20f@localdomain> <CAOQ4uxjC+ONu9nj-BJ8XwuWU0ofq5ySd-YRmXdikQjPAXj3WuA@mail.gmail.com>
 <CACTE=goi1H-rEKA4_2iZTsaW9k9k+kMCgnzWcZJBt4+-M93pmg@mail.gmail.com> <CAOQ4uxhKy1uWarTyAQqXmvk5nPsLYEsb1zgfSaSv-mcxby0+6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:32897 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756835AbdIHT4j (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 8 Sep 2017 15:56:39 -0400
Received: by mail-oi0-f53.google.com with SMTP id r20so20441972oie.0
        for <linux-unionfs@vger.kernel.org>; Fri, 08 Sep 2017 12:56:39 -0700 (PDT)
In-Reply-To: <CAOQ4uxhKy1uWarTyAQqXmvk5nPsLYEsb1zgfSaSv-mcxby0+6g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Sep 8, 2017 at 9:31 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> I see. Do you see any overlay fs warning in dmesg?
> Please send them as well.

The only overlay message is not an error,

kernel: ^[[0;1;39moverlayfs: fs on
'/tmp/live-net-remaster-ZpapXn/image/00filesystem.squashfs' does n\
ot support file handles, falling back to index=off.

> I did not understand if this happens during file create
> rename delete if you understand the scenario and can send a simple
> reproducer script that would be great.

after executing
touch /var/lib/dpkg/*
the first upgrade fails also,

I am not sure, but will try to do an script,
