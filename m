From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: Use designated initializers
Date: Tue, 4 Apr 2017 16:07:42 +0200
Message-ID: <CAJfpegtxTzu+ReqV3CaRbzh2kSRTkLEridPWTM4dNnkZX1v_eQ@mail.gmail.com>
References: <20170329210219.GA39900@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34107 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752213AbdDDOHn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Apr 2017 10:07:43 -0400
Received: by mail-oi0-f45.google.com with SMTP id d2so30930462oig.1
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Apr 2017 07:07:43 -0700 (PDT)
In-Reply-To: <20170329210219.GA39900@beast>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Mar 29, 2017 at 11:02 PM, Kees Cook <keescook@chromium.org> wrote:
> Prepare to mark sensitive kernel structures for randomization by making
> sure they're using designated initializers. These were identified during
> allyesconfig builds of x86, arm, and arm64, with most initializer fixes
> extracted from grsecurity.
>
> For these cases, use { }, which will be zero-filled, instead of
> undesignated NULLs.

Queued up for 4.12.

Thanks,
Miklos
