Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E88EC77B7A
	for <linux-unionfs@archiver.kernel.org>; Fri, 19 May 2023 20:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjESU4q (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 19 May 2023 16:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjESU4e (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 19 May 2023 16:56:34 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CA010CE
        for <linux-unionfs@vger.kernel.org>; Fri, 19 May 2023 13:56:23 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-76fffd0116eso28392739f.0
        for <linux-unionfs@vger.kernel.org>; Fri, 19 May 2023 13:56:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684529783; x=1687121783;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dAhsFZWzv4pW+FEJe+j1meXIun7sOpZm0ldqZGqi+6E=;
        b=hCYJwT+/KT1DewmeCK2OLU8lltMViu4yRm96xNyf8lrWC63vdg7hJUkxATVJn664pw
         atBA4dT0EpyT4x0lJfiIXEzfwoMiWPfBCv2HKeFoA33eY4BcrIOOFXXseOeJYvCMBggk
         JG3tjiJnpvUgFjbePGh62vdpMOEAM3kP2jV2+ftwiQ1sgSUg2VMDXRfiIBA5o38Q7Ecm
         0y+P6SvIzRjy2iNAH31hPtC3E/JLj/eD9ml3SOymoAi2tSqfqiFbsNpsfPBSQ5bd4q4e
         HDGIxmw3w9IgDmHvN/b9NmMHgEi1WzwpjIAh7Ei/pslWYyKLfWj60fwnniUpD5xIhBtt
         GcBQ==
X-Gm-Message-State: AC+VfDzN7k05rl0OEKCqa8S4kr57XFMqVbZG4NY3MjOEdA41e1jvgPn7
        4x2Vh9JNCOStASjnVp8DHhUmvR8DONQ+5QGd9bqCf6/2oEnC
X-Google-Smtp-Source: ACHHUZ5eBPeWyWaKDI49prhq7AsL0tX3Bj9eT6ivEGfM3LMeHkEYBzhvJHuqViDOaSy6/2UcdyP6aCq7gupAugrkOgoTWXQny1xM
MIME-Version: 1.0
X-Received: by 2002:a02:b0ca:0:b0:40f:ae69:a144 with SMTP id
 w10-20020a02b0ca000000b0040fae69a144mr1390179jah.5.1684529783286; Fri, 19 May
 2023 13:56:23 -0700 (PDT)
Date:   Fri, 19 May 2023 13:56:23 -0700
In-Reply-To: <0000000000001b987605f47b72d3@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000058b12b05fc122703@google.com>
Subject: Re: [syzbot] [reiserfs?] [overlayfs?] WARNING: locking bug in take_dentry_name_snapshot
From:   syzbot <syzbot+5a195884ee3ad761db4e@syzkaller.appspotmail.com>
To:     casey@schaufler-ca.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, paul@paul-moore.com,
        reiserfs-devel@vger.kernel.org, roberto.sassu@huawei.com,
        syzkaller-bugs@googlegroups.com, zohar@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 52ca4b6435a493e47aaa98e7345e19e1e8710b13
Author: Roberto Sassu <roberto.sassu@huawei.com>
Date:   Tue Mar 14 08:17:15 2023 +0000

    reiserfs: Switch to security_inode_init_security()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=121dea5a280000
start commit:   4bdec23f971b Merge tag 'hwmon-for-v6.3-rc4' of git://git.k..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=ea09b0836073ee4
dashboard link: https://syzkaller.appspot.com/bug?extid=5a195884ee3ad761db4e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1277fb1ec80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12543651c80000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: reiserfs: Switch to security_inode_init_security()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
