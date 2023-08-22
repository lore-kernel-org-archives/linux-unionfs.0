Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD361EE49AF
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Aug 2023 01:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbjHWBhG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 21:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjHWBhF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Aug 2023 21:37:05 -0400
X-Greylist: delayed 903 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Aug 2023 18:36:59 PDT
Received: from symantec4.comsats.net.pk (symantec4.comsats.net.pk [203.124.41.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE39E45
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 18:36:59 -0700 (PDT)
X-AuditID: cb7c291e-055ff70000002aeb-fc-64e54a4cbe6f
Received: from iesco.comsatshosting.com (iesco.comsatshosting.com [210.56.28.11])
        (using TLS with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by symantec4.comsats.net.pk (Symantec Messaging Gateway) with SMTP id 30.3A.10987.C4A45E46; Wed, 23 Aug 2023 04:52:44 +0500 (PKT)
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns;
        d=iesco.com.pk; s=default;
        h=received:content-type:mime-version:content-transfer-encoding
          :content-description:subject:to:from:date:reply-to;
        b=dn+DtPbWrBeTkKYgXZV5Mp5kzLCYZpLE3j5NNWOgQc89f1CpnMEEkcUNLi0bj+kdy
          HM/e9kR1FfReo1nMcrh3yTkX8ITw3hasy9E9KFB3TgiEw8Nkb+z6hfO6tCTxyniXA
          v/DLh0mvM8XjeTqa0yeUMqGH7NUyytlSc99ffwXXs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iesco.com.pk; s=default;
        h=reply-to:date:from:to:subject:content-description
          :content-transfer-encoding:mime-version:content-type;
        bh=GMzYzcyTxDsE6wX/XHG6MHqAdAiHrhqbmmLQ/TZ1QnQ=;
        b=GmvmGpbEFXYjr4E/rrs8fyF12ZyzfZl2FMwQ+OV0DNFFUCE3pjvSFH8xrH6OQ52Rz
          hXK9uJouBAs1aAmIrthTlwKaOy+mJqFcb9HM6RtUTY+C3qG0wS7fSJZaOAokucusA
          OFZJZLrgZlu0e8XW4KhTZrfAtI6hFN9AwfrkpyVTQ=
Received: from [94.156.6.90] (UnknownHost [94.156.6.90]) by iesco.comsatshosting.com with SMTP;
   Wed, 23 Aug 2023 04:31:08 +0500
Message-ID: <30.3A.10987.C4A45E46@symantec4.comsats.net.pk>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Re; Interest,
To:     linux-unionfs@vger.kernel.org
From:   "Chen Yun" <pso.chairmanbod@iesco.com.pk>
Date:   Tue, 22 Aug 2023 16:31:22 -0700
Reply-To: chnyne@gmail.com
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVyyUKGW9fH62mKwbfLRhZt19cwOjB6fN4k
        F8AYxWWTkpqTWZZapG+XwJWxZN0FloLdzBVt/YtYGhgfM3UxcnJICJhIfF9xjwXEFhLYwyQx
        6XFkFyMXB4vAamaJF4tWsUE4D5klNi7fwA7iCAk0M0p0n3jEDNLCK2At8fPNfFYQm1lAT+LG
        1ClsEHFBiZMzn7BAxLUlli18DVTPAWSrSXztKgEJCwuISXyatowdxBYRUJR433QXbCSbgL7E
        iq/NjCA2i4CqxJTTDUwQ10lJbLyynm0CI/8sJNtmIdk2C8m2WQjbFjCyrGKUKK7MTQSGWrKJ
        XnJ+bnFiSbFeXmqJXkH2JkZgGJ6u0ZTbwbj0UuIhRgEORiUe3p/rnqQIsSaWAXUdYpTgYFYS
        4ZX+/jBFiDclsbIqtSg/vqg0J7X4EKM0B4uSOK+t0LNkIYH0xJLU7NTUgtQimCwTB6dUA6OX
        QYCcpjy/o0Va7JfywBULg3M3pdVbbdkbv2nKtqSd4bI304svT2O2thD80ltb9TLygYKG0l6G
        Owv/v986j/1y2cTXBrHZS+x3Lzg1073obZ7qkglRNRZLgr+GhU7pKxOczpphfSYwvNLvdko6
        1941fjpKT7OK2z5bqB255uLfuuWabNYiTyWW4oxEQy3mouJEAPOlqa0/AgAA
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Re; Interest,

I am interested in discussing the Investment proposal as I explained
in my previous mail. May you let me know your interest and the
possibility of a cooperation aimed for mutual interest.

Looking forward to your mail for further discussion.

Regards

------
Chen Yun - Chairman of CREC
China Railway Engineering Corporation - CRECG
China Railway Plaza, No.69 Fuxing Road, Haidian District, Beijing, P.R.
China

