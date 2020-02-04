Return-Path: <SRS0=9nie=3Y=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6963DC3524D
	for <linux-unionfs@archiver.kernel.org>; Tue,  4 Feb 2020 10:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C2F820674
	for <linux-unionfs@archiver.kernel.org>; Tue,  4 Feb 2020 10:20:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="n+phWuRi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgBDKUJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 05:20:09 -0500
Received: from mail-io1-f54.google.com ([209.85.166.54]:45940 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgBDKUI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Feb 2020 05:20:08 -0500
Received: by mail-io1-f54.google.com with SMTP id i11so20215235ioi.12
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Feb 2020 02:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=rtWvxbFxRmS2DJppP4nF4FGfXrKAjyId7vxeppC6P00=;
        b=n+phWuRiPMFcdMUqgy2X2H155f0xKcVlEzpPdGmnl35HXWmdWEHDxmk1sJOTcQ8mT4
         bj1rAvjl/ZRBzVh70ZClZLFTkG1JGNXnaWZH8b/LIO4582FXPGOemXJGoyrsLIN4Dr8j
         tmj5eR9WdNDacmASOgPpMLQxnS94qr7jYG56c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=rtWvxbFxRmS2DJppP4nF4FGfXrKAjyId7vxeppC6P00=;
        b=k/s3Co28POfDNYWc+JBhmprtm6JvUxLwQ0sBnu4CplcXIrlQimjW6RAyVjGE5bWjkG
         H0jBUX3Ercz430ggnZXNtcoo0/Yk69CL0o7bpTWztEPpXpI9U+5zq+4NJF0G/+MwNdM4
         KotKPoMy00KLKXoc82XpSavbi3Jw3MFUNHMgdOr2nDN09McFkxAiqqbyPK3WPYW1ZdbG
         L9Y6TMoyPJf2Uq68gaPYmmjpN69MOpVbCZAisN0Y5dytPd/fppkTtX3jAfQMZR7xksJa
         FmtnLnIaykjkwRfrqkc8iHBRQ/sF1kc0j67fO8o+N0a+gE9n8XKkzU+g9Y/udYmI6kZd
         YW/w==
X-Gm-Message-State: APjAAAVMAS3eAB3o3L/cxovnyvkg6TBNfBFf7BchN+jMwddGfS676Ymn
        EcOZ1CLkbnMhO10x2WOeUnM1jm3hTRbXhMf+7LWkqQJHz7k=
X-Google-Smtp-Source: APXvYqzGseW8cI2ucUlZfKIiFirVTw3NDYWGWIhoYXrCRK9xAkjqp5Py/6g0GLOfRELyc8n03X7ONNrYYN6R0YjheR0=
X-Received: by 2002:a05:6638:3b6:: with SMTP id z22mr23073821jap.35.1580811608069;
 Tue, 04 Feb 2020 02:20:08 -0800 (PST)
MIME-Version: 1.0
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 4 Feb 2020 11:19:57 +0100
Message-ID: <CAJfpegtz4fRPL9pRBW_-3KbLwW5t+1Er3VR=tt5r7_eU9KtxFA@mail.gmail.com>
Subject: lore archive
To:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This list (linux-unionfs@vger.kernel.org) is now archived on lore:

   https://lore.kernel.org/linux-unionfs/

Thanks,
Miklos
