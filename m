Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A26DC433F5
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Sep 2021 14:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B21B60F43
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Sep 2021 14:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhIGOFL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 7 Sep 2021 10:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhIGOFJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Sep 2021 10:05:09 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635F3C061757
        for <linux-unionfs@vger.kernel.org>; Tue,  7 Sep 2021 07:04:03 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id z3so1754966uav.13
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Sep 2021 07:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VTa4HJUTB1E1dZjIkPVAASLfWDZL+qHUwuV+ayrSHns=;
        b=inAAuNIv+kI+xZOAB3EPk8wdYMUUsfj7bQDBPvEPuHgsxCGL2nhDmG3LE+HhdOcbOw
         lPrIDz7iTpgssZaKhgNCT6GVLHco2hYg/6mfEZyi3olJMD+CwWd7XLW4+7mfs5dKEIZE
         R9VG+5TLBrqOJb5NQyugyhRxUhAmbs9ehI2Y0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VTa4HJUTB1E1dZjIkPVAASLfWDZL+qHUwuV+ayrSHns=;
        b=tutFpGjESF4jFaZXChzQbUYXbjxkZiuWLoE5DbQoGG91bKaaltASNw+6sYjqpK6M6A
         OoGmIbue9aU8QL8kGk7wB5+zk51vMkzLw3y6XLOzGrugn0LmQP1/+JmuW8ZWrpbFQ/gK
         EseWQABFdtXFJwu6Q3atpoZA9SWemz5CAu/lpbCUskOUBdSAKGzNHJBD8LB2RLsL0oAx
         5i4gIJLW2Lak/2HUjMGQEM7zi2WdLcHtMFGoVqUX+J5QyNgr4ezZvB5oiEbx5gbBI17d
         OIb1y30dsQT7BR4BB1lqbNeuslo06J6fxbcZyYMyDlLAnY18T4gDH6xYCJP5qyn7Rxji
         l7Pw==
X-Gm-Message-State: AOAM533cKbmW1l3hCs5NUx5Yg7NVUn1ph9yJVTSL54Mx6y1J3xvBCWlw
        jXFrS0KPRbinvg43SKuJDC/NsrtnH8T4hdG3P7DEhw==
X-Google-Smtp-Source: ABdhPJzHZPZRuPRuZt20E9scsXEEBlFoT3cMFyw+EIRxLSIpN/j+ITmscvSnHyr2vYNsPuKFUBnq1obCZEM2sWB3bBc=
X-Received: by 2002:a9f:234a:: with SMTP id 68mr43793uae.13.1631023442512;
 Tue, 07 Sep 2021 07:04:02 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006dd93205cad885e5@google.com>
In-Reply-To: <0000000000006dd93205cad885e5@google.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 7 Sep 2021 16:03:49 +0200
Message-ID: <CAJfpegvOa5cT5eRTsaMtAJ0YfZ1ob_kuW-NNK-emu3ncp2pK7A@mail.gmail.com>
Subject: Re: [syzbot] WARNING in ovl_create_real
To:     syzbot <syzbot+75eab84fd0af9e8bf66b@syzkaller.appspotmail.com>
Cc:     linux-kernel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: multipart/mixed; boundary="000000000000e9785505cb683cfb"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--000000000000e9785505cb683cfb
Content-Type: text/plain; charset="UTF-8"

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
master

--000000000000e9785505cb683cfb
Content-Type: text/x-patch; charset="US-ASCII"; name="ovl-test.patch"
Content-Disposition: attachment; filename="ovl-test.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kta57rjk0>
X-Attachment-Id: f_kta57rjk0

ZGlmZiAtLWdpdCBhL2ZzL292ZXJsYXlmcy9kaXIuYyBiL2ZzL292ZXJsYXlmcy9kaXIuYwppbmRl
eCAxZmVmYjJiODk2MGUuLjBmNmMxMGVjNTZjMSAxMDA2NDQKLS0tIGEvZnMvb3ZlcmxheWZzL2Rp
ci5jCisrKyBiL2ZzL292ZXJsYXlmcy9kaXIuYwpAQCAtMTUwLDYgKzE1MCw5IEBAIHN0YXRpYyBp
bnQgb3ZsX21rZGlyX3JlYWwoc3RydWN0IGlub2RlICpkaXIsIHN0cnVjdCBkZW50cnkgKipuZXdk
ZW50cnksCiAJaWYgKGxpa2VseSghZF91bmhhc2hlZChkZW50cnkpKSkKIAkJcmV0dXJuIDA7CiAK
Kwlwcl9pbmZvKCJ1bmhhc2hlZCBkZW50cnkgYWZ0ZXIgbWtkaXIgKCVzKVxuIiwKKwkJZGVudHJ5
LT5kX3NiLT5zX3R5cGUtPm5hbWUpOworCiAJLyoKIAkgKiB2ZnNfbWtkaXIoKSBtYXkgc3VjY2Vl
ZCBhbmQgbGVhdmUgdGhlIGRlbnRyeSBwYXNzZWQKIAkgKiB0byBpdCB1bmhhc2hlZCBhbmQgbmVn
YXRpdmUuIElmIHRoYXQgaGFwcGVucywgdHJ5IHRvCkBAIC0yMDksNyArMjEyLDEwIEBAIHN0cnVj
dCBkZW50cnkgKm92bF9jcmVhdGVfcmVhbChzdHJ1Y3QgaW5vZGUgKmRpciwgc3RydWN0IGRlbnRy
eSAqbmV3ZGVudHJ5LAogCQkJZXJyID0gLUVQRVJNOwogCQl9CiAJfQotCWlmICghZXJyICYmIFdB
Uk5fT04oIW5ld2RlbnRyeS0+ZF9pbm9kZSkpIHsKKwlpZiAoIWVyciAmJiAhbmV3ZGVudHJ5LT5k
X2lub2RlKSB7CisJCXByX3dhcm4oIm5lZ2F0aXZlIGRlbnRyeSBhZnRlciBta2RpciAoJXMpXG4i
LAorCQkJbmV3ZGVudHJ5LT5kX3NiLT5zX3R5cGUtPm5hbWUpOworCQlXQVJOX09OKDEpOwogCQkv
KgogCQkgKiBOb3QgcXVpdGUgc3VyZSBpZiBub24taW5zdGFudGlhdGVkIGRlbnRyeSBpcyBsZWdh
bCBvciBub3QuCiAJCSAqIFZGUyBkb2Vzbid0IHNlZW0gdG8gY2FyZSBzbyBjaGVjayBhbmQgd2Fy
biBoZXJlLgo=
--000000000000e9785505cb683cfb--
