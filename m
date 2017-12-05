From: Miklos Szeredi <miklos@szeredi.hu>
Subject: test case for overwriting empty dir
Date: Tue, 5 Dec 2017 16:17:29 +0100
Message-ID: <CAJfpegswJ3Sc5te6XO=D2Pq4ghLP6Oz8TQ4T7t5BJzVs0CJk1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:46812 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752595AbdLEPRa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 Dec 2017 10:17:30 -0500
Received: by mail-qt0-f172.google.com with SMTP id r39so1434072qtr.13
        for <linux-unionfs@vger.kernel.org>; Tue, 05 Dec 2017 07:17:30 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, David Howells <dhowells@redhat.com>

Review by David revealed a bug introduced by commit

  38e813db61c3 (ovl: get rid of PURE type)

and fixed 15 commits later by

  5cf5b477f0ca (ovl: opaque cleanup)

Here's a test script (output should be "bar" not "bar foo"):

cd /tmp/
mkdir test
cd test
mkdir -p lower/dir1 upper work mnt
touch lower/dir1/foo
mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work mnt
mkdir mnt/dir2
touch mnt/dir2/bar
rm mnt/dir1/foo
mv -T mnt/dir2 mnt/dir1
umount mnt
mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work mnt
ls mnt/dir1
umount mnt
rm -r lower upper work mnt
cd /tmp
rmdir test

Can someone please make a proper testcase for this, if there isn't one already?

Thanks,
Miklos
