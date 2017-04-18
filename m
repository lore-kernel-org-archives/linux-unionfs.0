From: Rock Lee <rockdotlee@gmail.com>
Subject: Questions about redirect_fd feature
Date: Tue, 18 Apr 2017 20:59:22 +0800
Message-ID: <CAL-1w2uGpuFNCLycjUNNrWDZkdrtkZDGAkEtMOT7E34wdZYwtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:33839 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752819AbdDRM7X (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2017 08:59:23 -0400
Received: by mail-yb0-f178.google.com with SMTP id m133so36971933ybb.1
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2017 05:59:22 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org

Hi, Amir
I am a little confused. redirect_fd feature needs to wrt a file handle
to a xattr in upper dir, but what are the advantages ? Because it is
faster to lookup than ordinary lookup ? Could you please give me some
hints about why redirect by file handle is faster ?

BTW, there are too few comments in the overlayfs code which makes me
very hard to understand.

Thanks for your time.
-- 
Cheers,
Rock
