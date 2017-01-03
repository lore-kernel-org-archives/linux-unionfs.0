From: Linas Vepstas <linasvepstas@gmail.com>
Subject: Re: LXC+overlayfs in unprivileged mode
Date: Tue, 3 Jan 2017 10:08:25 -0600
Message-ID: <CAHrUA37+RWKXNCLuoyDufg+g3-TG5bLgSa_XwK5htmvb-omCcw@mail.gmail.com>
References: <CAHrUA37sR6ea6UNJZjbAHPWwkoTbtEg7Uq8Z1war9ODA23qcSw@mail.gmail.com>
 <CAOQ4uxi51_0C_-YVz_UYUbOWW3rSjmKv4NUkyxq0oCaWexZ6hw@mail.gmail.com>
 <CAHrUA3575TN8g9xZYrxShapjXy9M1ZWn8BEeZkK65zUJuPOffw@mail.gmail.com> <20170103134806.GA29807@redhat.com>
Reply-To: linasvepstas@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170103134806.GA29807@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Seth Forshee <seth.forshee@canonical.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jan 3, 2017 at 7:48 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sun, Jan 01, 2017 at 02:32:20PM -0600, Linas Vepstas wrote:
>
> [..]
>> It's somehow ironic that the push for user-space mounts and containers
>> comes from this general fuzzy sensation that they are somehow "safer",
>> yet the changes to enable this provide a new attack surface for
>> privilege escalation. Funny world we live in. :-)  Happy New Year!
>
> Only if unprivileged users want to be able to mount overlayfs. Otherwise, a
> privileged user can just mount overlayfs on host and bind mount that
> inside container (this is what docker does). And then you don't have
> to worry about allowing unprivileged users to be able to allow mounting.

:-(   The way that Ubuntu solves this is to carry patches to allow user-space
mounts.  Debian doesn't, which is how I tripped across this.  Anyway, Docker
and LXC are very different beasts: Docker makes for great demos, and
can get the occasional newbie going, but is kind of klunky and awkward
in real-life deployments.  It certainly fails to provide the ease-of-use and
flexibility that LXC offers.   (Docker tries to solve two unrelated problems,
and it handles both of them poorly: one problem is containerization, the
other problem is container build. LXC solves the first problem much more
elegantly, and completely ignores the second problem, which, in general,
is easily solved with shell scripts, so what was the point of Docker
reinventing a new kind of shell, badly?)

-- linas
