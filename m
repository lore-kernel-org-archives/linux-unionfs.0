Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF577C433F5
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Sep 2021 08:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFA0F60F5E
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Sep 2021 08:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbhIHIGw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 8 Sep 2021 04:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbhIHIGt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Sep 2021 04:06:49 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A157EC061757
        for <linux-unionfs@vger.kernel.org>; Wed,  8 Sep 2021 01:05:41 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id d6so1268104vsr.7
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Sep 2021 01:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GrCmiWZ+lLIF0BfI0o0K842eqHjzLf6yCvJO64151FM=;
        b=R3Ha0x9GrAuYWxwIbA/+/amGIhjGZfJ/X0mFyKoSoCPH7IETcl5PNMTxCOPN5r2dnZ
         XuzwSkS8QiHzsKeW96XLr0TDEfypDa7v0pZZ1Gy5py8UqmqGxorEfwT8RJl3+To5iEs+
         FWquYrLT64VfEkHljadi4Z0n1B8J3GccfFOFE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GrCmiWZ+lLIF0BfI0o0K842eqHjzLf6yCvJO64151FM=;
        b=GSmZISdV4fNpmOyUzN2fbR5wOEWg7qOhkU6Ox1wTf0im6qhF9C67DMoolxTPMQOjmC
         X40+Xd8pPv09/DCNOFjRJ359KvdVd1fgfTmlXxAiCOADZsdg2Jawn/4lDKtY4r3Xrkag
         aNBaVfRDzEsSHgg2faO+E2DYQ286SvE2pRSPQwq66bgaAhYzAopI4D7dbQJAKMN/X6ym
         5A3YVreXcRG2375U9f4QkGN5n5KYx+WsMg3Pk8cfo35+ygToAWFtcFzQDBT9170nTQ+C
         EUQ5aZVIp3mAGFFwhMh19p6nWRfZz4sO11Kr4zZ1PlPY+2MEolJtGwSy1RdSr9c9pa4G
         WxvQ==
X-Gm-Message-State: AOAM531+58hp17+Hzbnx89NOCg+6FBmIzo8a+QxNFIVOQqpV70Bn3Unt
        k0VLekXKtim3nFj3s5jNfx5krrNu5XO6EZCdRKJt1Q==
X-Google-Smtp-Source: ABdhPJzpU0nZYv8QXnsyxGxesr4frS1FXS9o50+ZSDrGthJucA4yqfXkuhFF+x6wBa62E8ur+KTAoIO+/bNHDxne3E4=
X-Received: by 2002:a05:6102:347:: with SMTP id e7mr1181597vsa.51.1631088340222;
 Wed, 08 Sep 2021 01:05:40 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006dd93205cad885e5@google.com> <CAJfpegvOa5cT5eRTsaMtAJ0YfZ1ob_kuW-NNK-emu3ncp2pK7A@mail.gmail.com>
In-Reply-To: <CAJfpegvOa5cT5eRTsaMtAJ0YfZ1ob_kuW-NNK-emu3ncp2pK7A@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 8 Sep 2021 10:05:29 +0200
Message-ID: <CAJfpegvVL-U3_4rhnhAU15qMAH-6WBuvmhnPMUkr_423R_2TOA@mail.gmail.com>
Subject: Re: [syzbot] WARNING in ovl_create_real
To:     syzbot <syzbot+75eab84fd0af9e8bf66b@syzkaller.appspotmail.com>
Cc:     linux-kernel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: multipart/mixed; boundary="0000000000001de82c05cb775997"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--0000000000001de82c05cb775997
Content-Type: text/plain; charset="UTF-8"

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
master

--0000000000001de82c05cb775997
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="ovl-fix-warning-in-ovl_create_real.patch"
Content-Disposition: attachment; 
	filename="ovl-fix-warning-in-ovl_create_real.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ktb7varr0>
X-Attachment-Id: f_ktb7varr0

ZGlmZiAtLWdpdCBhL2ZzL292ZXJsYXlmcy9kaXIuYyBiL2ZzL292ZXJsYXlmcy9kaXIuYwppbmRl
eCAxZmVmYjJiODk2MGUuLjJmNDEyNTM5OTg5NiAxMDA2NDQKLS0tIGEvZnMvb3ZlcmxheWZzL2Rp
ci5jCisrKyBiL2ZzL292ZXJsYXlmcy9kaXIuYwpAQCAtMTM3LDggKzEzNyw3IEBAIGludCBvdmxf
Y2xlYW51cF9hbmRfd2hpdGVvdXQoc3RydWN0IG92bF9mcyAqb2ZzLCBzdHJ1Y3QgaW5vZGUgKmRp
ciwKIAlnb3RvIG91dDsKIH0KIAotc3RhdGljIGludCBvdmxfbWtkaXJfcmVhbChzdHJ1Y3QgaW5v
ZGUgKmRpciwgc3RydWN0IGRlbnRyeSAqKm5ld2RlbnRyeSwKLQkJCSAgdW1vZGVfdCBtb2RlKQor
aW50IG92bF9ta2Rpcl9yZWFsKHN0cnVjdCBpbm9kZSAqZGlyLCBzdHJ1Y3QgZGVudHJ5ICoqbmV3
ZGVudHJ5LCB1bW9kZV90IG1vZGUpCiB7CiAJaW50IGVycjsKIAlzdHJ1Y3QgZGVudHJ5ICpkLCAq
ZGVudHJ5ID0gKm5ld2RlbnRyeTsKZGlmZiAtLWdpdCBhL2ZzL292ZXJsYXlmcy9vdmVybGF5ZnMu
aCBiL2ZzL292ZXJsYXlmcy9vdmVybGF5ZnMuaAppbmRleCAzODk0ZjMzNDc5NTUuLjJjZDU3NDFj
ODczYiAxMDA2NDQKLS0tIGEvZnMvb3ZlcmxheWZzL292ZXJsYXlmcy5oCisrKyBiL2ZzL292ZXJs
YXlmcy9vdmVybGF5ZnMuaApAQCAtNTcwLDYgKzU3MCw3IEBAIHN0cnVjdCBvdmxfY2F0dHIgewog
CiAjZGVmaW5lIE9WTF9DQVRUUihtKSAoJihzdHJ1Y3Qgb3ZsX2NhdHRyKSB7IC5tb2RlID0gKG0p
IH0pCiAKK2ludCBvdmxfbWtkaXJfcmVhbChzdHJ1Y3QgaW5vZGUgKmRpciwgc3RydWN0IGRlbnRy
eSAqKm5ld2RlbnRyeSwgdW1vZGVfdCBtb2RlKTsKIHN0cnVjdCBkZW50cnkgKm92bF9jcmVhdGVf
cmVhbChzdHJ1Y3QgaW5vZGUgKmRpciwgc3RydWN0IGRlbnRyeSAqbmV3ZGVudHJ5LAogCQkJICAg
ICAgIHN0cnVjdCBvdmxfY2F0dHIgKmF0dHIpOwogaW50IG92bF9jbGVhbnVwKHN0cnVjdCBpbm9k
ZSAqZGlyLCBzdHJ1Y3QgZGVudHJ5ICpkZW50cnkpOwpkaWZmIC0tZ2l0IGEvZnMvb3ZlcmxheWZz
L3N1cGVyLmMgYi9mcy9vdmVybGF5ZnMvc3VwZXIuYwppbmRleCAxNzhkYWE1ZTgyYzkuLjI2NTE4
MWMxMTBhZSAxMDA2NDQKLS0tIGEvZnMvb3ZlcmxheWZzL3N1cGVyLmMKKysrIGIvZnMvb3Zlcmxh
eWZzL3N1cGVyLmMKQEAgLTc4NywxMCArNzg3LDE0IEBAIHN0YXRpYyBzdHJ1Y3QgZGVudHJ5ICpv
dmxfd29ya2Rpcl9jcmVhdGUoc3RydWN0IG92bF9mcyAqb2ZzLAogCQkJZ290byByZXRyeTsKIAkJ
fQogCi0JCXdvcmsgPSBvdmxfY3JlYXRlX3JlYWwoZGlyLCB3b3JrLCBPVkxfQ0FUVFIoYXR0ci5p
YV9tb2RlKSk7Ci0JCWVyciA9IFBUUl9FUlIod29yayk7Ci0JCWlmIChJU19FUlIod29yaykpCi0J
CQlnb3RvIG91dF9lcnI7CisJCWVyciA9IG92bF9ta2Rpcl9yZWFsKGRpciwgJndvcmssIGF0dHIu
aWFfbW9kZSk7CisJCWlmIChlcnIpCisJCQlnb3RvIG91dF9kcHV0OworCisJCS8qIFdlaXJkIGZp
bGVzeXN0ZW0gcmV0dXJuaW5nIHdpdGggaGFzaGVkIG5lZ2F0aXZlIChrZXJuZnMpPyAqLworCQll
cnIgPSAtRUlOVkFMOworCQlpZiAoZF9yZWFsbHlfaXNfbmVnYXRpdmUod29yaykpCisJCQlnb3Rv
IG91dF9kcHV0OwogCiAJCS8qCiAJCSAqIFRyeSB0byByZW1vdmUgUE9TSVggQUNMIHhhdHRycyBm
cm9tIHdvcmtkaXIuICBXZSBhcmUgZ29vZCBpZjoK
--0000000000001de82c05cb775997--
