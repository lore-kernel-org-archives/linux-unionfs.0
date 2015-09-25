From: Alexey Naidyonov <alexey.naidyonov@gmail.com>
Subject: Re: overlayfs + linux user namespace issue
Date: Fri, 25 Sep 2015 11:54:26 +0300
Message-ID: <CAM45riaczs59=SaQBJkdV-Eoenp8Osd4zXTEhZfC_gj1Pn2zDg@mail.gmail.com>
References: <CAM45rib8eDrSkRwXo+0ZhannWNmyUe1Tqq9T13csGVdfWXbwXw@mail.gmail.com>
	<20150924111632.GA19632@bark>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:36813 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbbIYIy3 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 25 Sep 2015 04:54:29 -0400
Received: by lacao8 with SMTP id ao8so90800625lac.3
        for <linux-unionfs@vger.kernel.org>; Fri, 25 Sep 2015 01:54:27 -0700 (PDT)
In-Reply-To: <20150924111632.GA19632@bark>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hello Andy;

> Which directory are you saying must belong to namespace root here?
> You should not be able to read things in the underlay that the namespace
> root could not read, and not write to overlay directories that your
> namepsace root cannot write.  If you could you could copy up protected
> files into an overlay by specifying a protected underlay (think ~/over
> overlaying on /etc) or overwrite profiled files by specifying a protected
> overlay (think ~/under overlayed by /etc).

Both upper and lower directory belong to uid 200 000 (which is uid 0
inside user namespace). The work directory is created by overlayfs
itself under directory specified by workdir= option, with uid=0
ownership.

I would like to emphasize that non-root process can write to a
overlayfs mount with no problem. The issue arises only when process
switches to its own user namespace.

So, we have two scenarios:
1) a non-root process with uid of the owner of upper directory can
perfectly write to an overlayfs mount
2) a non-root process with uid of the owner of upper directory
sometimes gets denied writing to an overlayfs mount, but only if this
process is inside its own user namespace and has uid=0 there

Thank you.

Regards,
--
 Alexey Naidyonov
