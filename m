From: Linas Vepstas <linasvepstas@gmail.com>
Subject: LXC+overlayfs in unprivileged mode
Date: Sat, 31 Dec 2016 11:42:43 -0600
Message-ID: <CAHrUA37sR6ea6UNJZjbAHPWwkoTbtEg7Uq8Z1war9ODA23qcSw@mail.gmail.com>
Reply-To: linasvepstas@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Vivek Goyal <vgoyal@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

Hi,

I tripped across an LXC bug that actually appears to be an overlayfs
security feature (maybe) and was wondering how to clarify the status
of the code. Apparently, Ubuntu is carrying patches that enable this
function, and so the question is if these or something more appropriate
can be pulled into the mainline kernel or into overlayfs (or perhaps they
have been already; the situation is confusing).

The issue is that LXC+overlayfs seems to not work in an unprivileged
container. A more detailed description, with a particularly simple test
case is given in https://github.com/lxc/lxc/issues/1370#issuecomment269845311
Based on searches through google, it seems likely that the reason it
does not work is due to one or more privilege-escalation exploits,
except that these may or may not be patched already... thus this email.

Any advice on how to proceed?

--linas
