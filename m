From: Rock Lee <rockdotlee@gmail.com>
Subject: copy up questions
Date: Sat, 8 Apr 2017 20:45:26 +0800
Message-ID: <CAL-1w2sXhnGVW5-3AyUgSjEy4ebk1ftDzoaadhn9n4_Qf7kD8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:34085 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751997AbdDHMp1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 8 Apr 2017 08:45:27 -0400
Received: by mail-yw0-f173.google.com with SMTP id p77so44302404ywg.1
        for <linux-unionfs@vger.kernel.org>; Sat, 08 Apr 2017 05:45:27 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org

Hi:
    I am reading the code of overlayfs and have some questions about copy-up.
If a file which doesn't exist on upper directory is modified, this file will
be copied to work directory and then be renamed to upper directory.

1. It seems the whole file(in lower directory) will be copied, that will be
    a big cost in time and space. Is there any way to just copy the
modifed part?
    Like "cp --reflink", keep the modified part in upper directory?

2. What's the purpose of renaming a file from work directory to upper directory?
    Because rename is atomic?

3. When you talk about "a persistent file handle", what's the exact
form of "file handle",
    is it "struct file * file"?

My questions may be silly, I would appreciate it if you could give me
a bit of hint.
