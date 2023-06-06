Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 941E1C7EE2C
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbjFFJOJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbjFFJNu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Jun 2023 05:13:50 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BE5E7E
        for <linux-unionfs@vger.kernel.org>; Tue,  6 Jun 2023 02:13:40 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-51492ae66a4so8184096a12.1
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Jun 2023 02:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1686042819; x=1688634819;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v/09YTa8tEcJwJTMpIH6M+tZT3IBJvAj9v+wpVe650k=;
        b=ZIYbKwYf4fG/ucLfaj3THNnjwZUxrgo+Srnk+9+rBk0CRFNwAtZw4hjG6K4p7Bbhp8
         Djs6Noh9VbDKG1qN2s4+ONprYk2kT30Qi2JWKabiVGu7cqXOzgJQbQvi2Xi0cSJfSb7s
         stnhvpC8tgmsk/SP99zWYcIm9TAX92jxvTLeg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686042819; x=1688634819;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v/09YTa8tEcJwJTMpIH6M+tZT3IBJvAj9v+wpVe650k=;
        b=LtjEvEZaZANXSRqm/unTogFuLWSvrEPgTNetcZIK4LChSlfLZQKsfrIRHc4XWWErd1
         WC8cJ50FmgKV6PMql3QnJkn8gMP0dj3AEffp6dyMVzbY+2n2RmQ5duHuqNjzSxgqKiXi
         AXGtNK07sgY2FtNdVygsADVxk23dX8Un38Ss3lGPRsZXznf/GC+sizx2w6dTPyN0Zl4L
         wT5MI6XvKLDvoY1vRjMGU1p/wEQ2iFmwIf1ACwZVQ+uPgqOMzoT+srcG/YvPFesHCUFa
         lUokAMogQYjpWgi4ATvwU3R53NbYZBNd7AtY3tjN+Y9wuTni8vuryWXAWX55RvXSgrzh
         5taw==
X-Gm-Message-State: AC+VfDzHm01nY91gS8Q4PXXD/EwTD6OQJVnZE95EWHuXFf1kHjRfA8DO
        jy3eCxpII60bXGTn4jKEyVdo0Vsu3H4hsoajFHRqBg==
X-Google-Smtp-Source: ACHHUZ4vPzst/oCRoU4YoFhlm/1DWVKqEkFpcNkc6lS7e2xnXC1wXYrpZDXM97TMUEU9m7Y2OTbiyc0y1qBLlGN+UvM=
X-Received: by 2002:a17:907:60d4:b0:96f:5747:a0de with SMTP id
 hv20-20020a17090760d400b0096f5747a0demr1545860ejc.6.1686042819365; Tue, 06
 Jun 2023 02:13:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegtzZnzW506AHyw_5Bqn-thhrd3-_t-qJ5OJBzP-z3O6Fg@mail.gmail.com>
 <00000000000090dbc405fd726b57@google.com>
In-Reply-To: <00000000000090dbc405fd726b57@google.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 6 Jun 2023 11:13:27 +0200
Message-ID: <CAJfpegtFrY9oq9ZSB_ZJenDcVLoOqVKxZY71gi+1f295zsmzyQ@mail.gmail.com>
Subject: Re: [syzbot] possible deadlock in mnt_want_write (2)
To:     syzbot <syzbot+b42fe626038981fb7bfa@syzkaller.appspotmail.com>
Cc:     linux-integrity@vger.kernel.org, linux-unionfs@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

#syz set subsystems: integrity, overlayfs


On Tue, 6 Jun 2023 at 11:12, syzbot
<syzbot+b42fe626038981fb7bfa@syzkaller.appspotmail.com> wrote:
>
> > #syz set subsystems: intergrity, overlayfs
>
> The specified label value is incorrect.
> "intergrity" is not among the allowed values.
> Please use one of the supported label values.
>
> The following labels are suported:
> missing-backport, no-reminders, prio: {low, normal, high}, subsystems: {.. see below ..}
> The list of subsystems: https://syzkaller.appspot.com/upstream/subsystems?all=true
>
