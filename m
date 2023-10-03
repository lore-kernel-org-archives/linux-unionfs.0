Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7256BE75434
	for <linux-unionfs@archiver.kernel.org>; Tue,  3 Oct 2023 08:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239270AbjJCIGm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 04:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbjJCIGl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 3 Oct 2023 04:06:41 -0400
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F91AC
        for <linux-unionfs@vger.kernel.org>; Tue,  3 Oct 2023 01:06:38 -0700 (PDT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6c4b9cab821so748458a34.0
        for <linux-unionfs@vger.kernel.org>; Tue, 03 Oct 2023 01:06:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696320398; x=1696925198;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E3/2NqW9mmT03VqQNExZ1WshExaLoGoulxK0Isrbhfw=;
        b=PopN6b5fDmCtXF3avUpQJTviEQaFUPqMNMHJbuByVwdGQcEQS41vC0aM9lOgGFTQbi
         LPsIl6CzutswSNrb8fwO/kQgYW0PuXeVoKKguZXJ+VExmZXDjDA0EHgk7AKq/z5MkSO1
         fSIC1y68lbqJMyak9RtZThhUn2rq0dULP+Ca5++2/qA12pS8BwdWEwHFCVJkZTJPZ9Z8
         ymhjxyUo5u1maTq9fVUGCRm7aeJbtFcCK0tAdeeGfdsDIr7q/VWDY/kRcaipnyXnOkI9
         0QT2vqxfs22EdzqnKJoxSD7GwkjNRjXzzhrE6ZgkEkyVrmOVlwj4xLW0DHiNyV07k2Mu
         N68Q==
X-Gm-Message-State: AOJu0Yzk5aN352GeO4NZQverwt8XNuThHuG6NCb8lfRbmaI1nSN0zHMp
        u05nNwc3X/3jubsj2PL+UUsOxO6PKuZAm/UKDwhGxClWxn2Q
X-Google-Smtp-Source: AGHT+IHvp7PrTwxGiy8U8miYCuYFgnGiIsw0EIZoLoqOGVXyX4sMUzTfWVSkKU/1qrUSX1Sdo4ECGlic4zPUSXnlRVMYOfZUCHDK
MIME-Version: 1.0
X-Received: by 2002:a9d:7c81:0:b0:6b7:3eba:59d3 with SMTP id
 q1-20020a9d7c81000000b006b73eba59d3mr4004601otn.6.1696320397970; Tue, 03 Oct
 2023 01:06:37 -0700 (PDT)
Date:   Tue, 03 Oct 2023 01:06:37 -0700
In-Reply-To: <CAOQ4uxhgWHoauPKUDfmuvu9uyMC23gkKVgi98R7XgX6s+fuh7w@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bf12400606cb5e6b@google.com>
Subject: Re: [syzbot] [overlayfs?] general protection fault in ovl_encode_real_fh
From:   syzbot <syzbot+2208f82282740c1c8915@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+2208f82282740c1c8915@syzkaller.appspotmail.com

Tested on:

commit:         c7242a45 ovl: fix NULL pointer defer when encoding non..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=11f4879e680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=57da1ac039c4c78a
dashboard link: https://syzkaller.appspot.com/bug?extid=2208f82282740c1c8915
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
