Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B16C072A2
	for <linux-unionfs@archiver.kernel.org>; Fri, 17 Nov 2023 19:44:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbjKQTot (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 17 Nov 2023 14:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjKQTos (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Nov 2023 14:44:48 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD4AD5C
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Nov 2023 11:44:45 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id 3f1490d57ef6-da41acaea52so2261679276.3
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Nov 2023 11:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1700250285; x=1700855085; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oNnLhnVkW8BLPIaZVQ396kNaqwizVhGjMn5jPeFrazs=;
        b=M/ICQqWSPG8Zyu2DC5ldSSLhion3j2Qe7YQ3WFkneNwXotK3hNFKzBCZN/mxXx9Nep
         9oePPZo8Y6VbD/NKaBf2FEYcHwn/3147AogQM0qRBCVJngWmYXWkHoWo6L6L8z7G5BPy
         S4HfkjIUi+4csKId3JOb3/plp3pZYiF0+8g7eQM43EPvpbJnxrnkNR6o9qt2Fkxo7WnN
         aDeJh0PDBKcpvN/msDsWrbElnHUaG6CaZS80J3/GviJWClXePtsOmP6ZPIsylXAGc7Ww
         1ZIqnDRG5yT5qmlSX4iWUZDkLD/CapQ3g7aIgdChCxmYfQBtMXPNX/yjgGmo7QEn3QWW
         v+Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700250285; x=1700855085;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oNnLhnVkW8BLPIaZVQ396kNaqwizVhGjMn5jPeFrazs=;
        b=sRQf54KeFa146D6vr3wiYyGoLlyiwhamHSpXd+Hdk49OzFGRge+bU4Wy6J3UuW9EBg
         T0RWJ2Abweh+TuopqHtCnnI9T8LVo7dKZMZsUs4ZFL5v2T/DBP+hlMHJn7Hx5rPermUK
         Jd1bFwmJTNf3YA/KoivOMbd+FUs5iiLKhNVBc17HEBc9R8dV7SDdUvmz61eFAsVv5dr9
         QkfIV9T1NJkOhc+g8U4zcPgsjqt9Vw2a6tob92151V9D3c+94ssWTpPMQb0DJAxhOHnZ
         HVzNWLbhz2AogN/1pRT/5wMYnvLgy+3sbacVYbbrP3PDbPRnDn0blRBsOV24U10Dm1Me
         1OTw==
X-Gm-Message-State: AOJu0YyqxBgi87Xo1150v2NdKORxc+fKkR4gKm7/LRPRrmzJCM37JHBE
        jXP9ZZTgnLmlpQiSFwBYjCZDxw==
X-Google-Smtp-Source: AGHT+IEZC06WOgTMLHvfauRST7K1Dgt2wRUqf497ohqgoPF9N9NXb0gMOjf5dvdgr7Xe+bBquMn52w==
X-Received: by 2002:a25:818f:0:b0:d9b:4b94:adf5 with SMTP id p15-20020a25818f000000b00d9b4b94adf5mr377060ybk.14.1700250284791;
        Fri, 17 Nov 2023 11:44:44 -0800 (PST)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id a8-20020a25ae08000000b00da07d9e47b4sm562083ybj.55.2023.11.17.11.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Nov 2023 11:44:44 -0800 (PST)
Date:   Fri, 17 Nov 2023 14:44:43 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH 00/15] Tidy up file permission hooks
Message-ID: <20231117194443.GC1513185@perftesting>
References: <20231114153254.1715969-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231114153254.1715969-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Nov 14, 2023 at 05:32:39PM +0200, Amir Goldstein wrote:
> Hi Christian,
> 
> I realize you won't have time to review this week, but wanted to get
> this series out for review for a wider audience soon.
> 
> During my work on fanotify "pre content" events [1], Jan and I noticed
> some inconsistencies in the call sites of security_file_permission()
> hooks inside rw_verify_area() and remap_verify_area().
> 
> The majority of call sites are before file_start_write(), which is how
> we want them to be for fanotify "pre content" events.
> 
> For splice code, there are many duplicate calls to rw_verify_area()
> for the entire range as well as for partial ranges inside iterator.
> 
> This cleanup series, mostly following Jan's suggestions, moves all
> the security_file_permission() hooks before file_start_write() and
> eliminates duplicate permission hook calls in the same call chain.
> 
> The last 3 patches are helpers that I used in fanotify patches to
> assert that permission hooks are called with expected locking scope.
> 
> My hope is to get this work reviewed and staged in the vfs tree
> for the 6.8 cycle, so that I can send Jan fanotify patches for
> "pre content" events based on a stable branch in the vfs tree.
> 
> Thanks,
> Amir.

Amir,

The last 3 patches didn't make it onto lore for some reason, so I can't review
the last 3.  Thanks,

Josef 
