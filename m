Return-Path: <SRS0=HZ4d=46=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87755C10DCE
	for <linux-unionfs@archiver.kernel.org>; Fri, 13 Mar 2020 08:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15787206FA
	for <linux-unionfs@archiver.kernel.org>; Fri, 13 Mar 2020 08:53:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="PFyhdwTU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgCMIxz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 04:53:55 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:42254 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgCMIxz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 13 Mar 2020 04:53:55 -0400
Received: by mail-il1-f196.google.com with SMTP id p2so336088ile.9
        for <linux-unionfs@vger.kernel.org>; Fri, 13 Mar 2020 01:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hEtT8H9r/rZLXOf4yHOAUmsYOn8BGa21+Hy5KXhtNdw=;
        b=PFyhdwTU+O0Wft/p8BQfeIuCDyGs4EhCjo5AmXwVY8iAr8qQ1wjv6RUfqwGThCr/F0
         5+YJ/c1G1pjfpOn7QevIMOtlddv63++z0xjOSwrcv9Hffr6Js61V8964pjTNHKVoYKap
         TtqzEuakjRoGheFEBeGgNJ9pRbU+fmeLteaYM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hEtT8H9r/rZLXOf4yHOAUmsYOn8BGa21+Hy5KXhtNdw=;
        b=soMueBU+yk0RdQoiToYz4txTkRLYhcwTOumDLVIGMrVJy0ANIbdSMbUzonLV0k30+p
         0v8bbaCW1PHubhhRrb3CAynUZpg+uMLC3MaPxi4x4AJs0KZInUa5LK+megVhS25n/iFW
         ONYGGU6HtCj5i9OufjBYhozcV0K6Bkfi057rfPU7JJZb2ufDA3H4/ltjwarXCLwXlMKr
         /YWdMoWNypQc22rrTRHLiWaqIuvyZIxr7+hrQnCg31bkFlBzDsasJxI8pMbt1pKJKe4X
         bCzl7fQogaXVOdIE66UL0t2cAcfvlIoJOndb3nSMPVsCO9G0RFUguZWFFmkgWPeo+IyL
         dEoA==
X-Gm-Message-State: ANhLgQ35jGI2gbnKmxl4jAO3ihVo6QKX/yfjm1NFY0u9Mg1SOUDseMKz
        E5xOr1ORqaWgN8148/160LMGkohIMwar27a2dXj1uw==
X-Google-Smtp-Source: ADFU+vtCORTQtZ0GaACujZv6kK12KQwym47yb46Vt5xMaRvWPsHFtqOM5hfGvnjrnf0HMO7x56B7t5WqAzQUoGeJEXs=
X-Received: by 2002:a92:2452:: with SMTP id k79mr231597ilk.174.1584089633904;
 Fri, 13 Mar 2020 01:53:53 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000cc1faf059fcfdc73@google.com>
In-Reply-To: <000000000000cc1faf059fcfdc73@google.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 13 Mar 2020 09:53:42 +0100
Message-ID: <CAJfpegtd603jRNKnwFdNw4HffC7nj08YzWOrm3x=mf0ZwHzoOw@mail.gmail.com>
Subject: Re: WARNING: lock held when returning to user space in ovl_write_iter
To:     syzbot <syzbot+9331a354f4f624a52a55@syzkaller.appspotmail.com>
Cc:     Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        linux-kernel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: multipart/mixed; boundary="000000000000ec8bcf05a0b89bc7"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

--000000000000ec8bcf05a0b89bc7
Content-Type: text/plain; charset="UTF-8"

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
63623fd4

--000000000000ec8bcf05a0b89bc7
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="ovl-fix-lockdep-warning-for-async-write.patch"
Content-Disposition: attachment; 
	filename="ovl-fix-lockdep-warning-for-async-write.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k7py202s0>
X-Attachment-Id: f_k7py202s0

LS0tCiBmcy9vdmVybGF5ZnMvZmlsZS5jIHwgICAgNiArKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA2
IGluc2VydGlvbnMoKykKCi0tLSBhL2ZzL292ZXJsYXlmcy9maWxlLmMKKysrIGIvZnMvb3Zlcmxh
eWZzL2ZpbGUuYwpAQCAtMjQ0LDYgKzI0NCw5IEBAIHN0YXRpYyB2b2lkIG92bF9haW9fY2xlYW51
cF9oYW5kbGVyKHN0cnUKIAlpZiAoaW9jYi0+a2lfZmxhZ3MgJiBJT0NCX1dSSVRFKSB7CiAJCXN0
cnVjdCBpbm9kZSAqaW5vZGUgPSBmaWxlX2lub2RlKG9yaWdfaW9jYi0+a2lfZmlscCk7CiAKKwkJ
LyogQWN0dWFsbHkgYWNxdWlyZWQgaW4gb3ZsX3dyaXRlX2l0ZXIoKSAqLworCQlfX3NiX3dyaXRl
cnNfYWNxdWlyZWQoZmlsZV9pbm9kZShpb2NiLT5raV9maWxwKS0+aV9zYiwKKwkJCQkgICAgICBT
Ql9GUkVFWkVfV1JJVEUpOwogCQlmaWxlX2VuZF93cml0ZShpb2NiLT5raV9maWxwKTsKIAkJb3Zs
X2NvcHlhdHRyKG92bF9pbm9kZV9yZWFsKGlub2RlKSwgaW5vZGUpOwogCX0KQEAgLTM0Niw2ICsz
NDksOSBAQCBzdGF0aWMgc3NpemVfdCBvdmxfd3JpdGVfaXRlcihzdHJ1Y3Qga2lvCiAJCQlnb3Rv
IG91dDsKIAogCQlmaWxlX3N0YXJ0X3dyaXRlKHJlYWwuZmlsZSk7CisJCS8qIFBhY2lmeSBsb2Nr
ZGVwLCBzYW1lIHRyaWNrIGFzIGRvbmUgaW4gYWlvX3dyaXRlKCkgKi8KKwkJX19zYl93cml0ZXJz
X3JlbGVhc2UoZmlsZV9pbm9kZShyZWFsLmZpbGUpLT5pX3NiLAorCQkJCSAgICAgU0JfRlJFRVpF
X1dSSVRFKTsKIAkJYWlvX3JlcS0+ZmQgPSByZWFsOwogCQlyZWFsLmZsYWdzID0gMDsKIAkJYWlv
X3JlcS0+b3JpZ19pb2NiID0gaW9jYjsK
--000000000000ec8bcf05a0b89bc7--
