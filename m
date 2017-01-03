From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: LXC+overlayfs in unprivileged mode
Date: Tue, 3 Jan 2017 08:48:06 -0500
Message-ID: <20170103134806.GA29807@redhat.com>
References: <CAHrUA37sR6ea6UNJZjbAHPWwkoTbtEg7Uq8Z1war9ODA23qcSw@mail.gmail.com>
 <CAOQ4uxi51_0C_-YVz_UYUbOWW3rSjmKv4NUkyxq0oCaWexZ6hw@mail.gmail.com>
 <CAHrUA3575TN8g9xZYrxShapjXy9M1ZWn8BEeZkK65zUJuPOffw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHrUA3575TN8g9xZYrxShapjXy9M1ZWn8BEeZkK65zUJuPOffw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linas Vepstas <linasvepstas@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Seth Forshee <seth.forshee@canonical.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-unionfs@vger.kernel.org

On Sun, Jan 01, 2017 at 02:32:20PM -0600, Linas Vepstas wrote:

[..]
> It's somehow ironic that the push for user-space mounts and containers
> comes from this general fuzzy sensation that they are somehow "safer",
> yet the changes to enable this provide a new attack surface for
> privilege escalation. Funny world we live in. :-)  Happy New Year!

Only if unprivileged users want to be able to mount overlayfs. Otherwise, a
privileged user can just mount overlayfs on host and bind mount that
inside container (this is what docker does). And then you don't have
to worry about allowing unprivileged users to be able to allow mounting.

Vivek
